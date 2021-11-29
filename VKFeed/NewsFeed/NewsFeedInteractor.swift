//
//  NewsFeedInteractor.swift
//  VKFeed
//
//  Created by Артем Хребтов on 25.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsFeedBusinessLogic {
    func makeRequest(request: NewsFeed.Model.Request.RequestType)
}

class NewsFeedInteractor: NewsFeedBusinessLogic {
    
    var presenter: NewsFeedPresentationLogic?
    var service: NewsFeedService?
    private var revealedPostId = [Int]()
    private var feedResponse: FeedResponse?
    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
    
    func makeRequest(request: NewsFeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsFeedService()
        }
        switch request {
        //кейс получить всю новостную ленту
        case .getNewsfeed:
            //делаем сетевой запрос
            fetcher.getFeed {[weak self] feedResponse in
                self?.feedResponse = feedResponse
                self?.presentFeed()
            }
        //кейс по нажатию кнопки показать больше текста
        case .revealPostId(postId: let postId):
            revealedPostId.append(postId)
            presentFeed()
        case .getUser:
            fetcher.getUser { user in
                self.presenter?.presentData(response: .presentUserInfo(user: user))
                
            }
        }
        
    }
    //делаем запрос в презентер
    private func presentFeed(){
        guard let feedResponse = feedResponse else { return }
        presenter?.presentData(response: .presentNewsFeed(feed: feedResponse, revealedPostId: revealedPostId))
    }
}
