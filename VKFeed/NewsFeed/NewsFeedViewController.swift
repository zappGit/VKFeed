//
//  NewsFeedViewController.swift
//  VKFeed
//
//  Created by Артем Хребтов on 25.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsFeedDisplayLogic: AnyObject {
  func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData)
}

class NewsFeedViewController: UIViewController, NewsFeedDisplayLogic, NewsfeedCodeCellDelegate {
  var interactor: NewsFeedBusinessLogic?
    private var titleView = TitleView()
  var router: (NSObjectProtocol & NewsFeedRoutingLogic)?
    //модель ленты новостей, как массив ячеек, заполненных согласно модели ячейки
    private var feedViewModel = FeedViewModel.init(cells: [])
    
    @IBOutlet weak var table: UITableView!
    // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = NewsFeedInteractor()
    let presenter             = NewsFeedPresenter()
    let router                = NewsFeedRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
    private var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refresher), for: .valueChanged)
        return refresh
    }()
  // MARK: Routing
  

  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
      
      view.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
      setupTopBar()
      setupTable()
      //запрос итератору
      interactor?.makeRequest(request: .getNewsfeed)
      interactor?.makeRequest(request: .getUser)
  }
    
    private func setupTable(){
        //table.register(UINib(nibName: "NewsfeedCell", bundle: nil), forCellReuseIdentifier: NewsfeedCell.reuseId)
        //Регистрируем ячеку
        let topInsert: CGFloat = 8
        table.contentInset.top = topInsert
        
        table.register(NewsFeedCodeCell.self, forCellReuseIdentifier: NewsFeedCodeCell.reuseId)
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.addSubview(refreshControl)
    }
    
    private func setupTopBar() {
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.titleView = titleView
    }
    
    @objc private func refresher() {
        interactor?.makeRequest(request: .getNewsfeed)
    }
  
  func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData) {
      switch viewModel {
      case .displayNewsFeed(feedViewModel: let feedViewModel):
          self.feedViewModel = feedViewModel
          table.reloadData()
          refreshControl.endRefreshing()
      case .displayUser(userViewModel: let userViewModel):
          titleView.set(userViewModeL: userViewModel)
      }
  }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.1 {
            interactor?.makeRequest(request: .getnextButch)
        }
    }
    
    //MARK: NewsfeedCodeCellDelegate
    //передаем ячейку в которой нажили кнопку показать весь текст
    func revealPost(for cell: NewsFeedCodeCell) {
        //получаем индекс ячейки
        guard let indexPath = table.indexPath(for: cell) else { return }
        let cellViewModel = feedViewModel.cells[indexPath.row]
        //делаем запрос итератору
        interactor?.makeRequest(request: .revealPostId(postId: cellViewModel.postId))
    }
}

extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedCell.reuseId, for: indexPath) as! NewsfeedCell
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedCodeCell.reuseId, for: indexPath) as! NewsFeedCodeCell
        let cellViewModel = feedViewModel.cells[indexPath.row]
        //заполняем ячейку полученными данными
        cell.set(viewModel: cellViewModel)
        //делаем ячейку делегатом для кнопки показать больше текста
        cell.delegate = self
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cells[indexPath.row]
        //автоматически задаем высоту ячейки, согласно подсчитанным данным
        return cellViewModel.sizes.totalHeight
        
    }
    //вспомогательная функция для упрощения работы приложения по высчитываю высоты ячейки при нажатии на кнопку показать больше
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
}
