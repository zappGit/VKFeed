//
//  NewsFeedPresenter.swift
//  VKFeed
//
//  Created by Артем Хребтов on 25.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsFeedPresentationLogic {
  func presentData(response: NewsFeed.Model.Response.ResponseType)
}

class NewsFeedPresenter: NewsFeedPresentationLogic {
  weak var viewController: NewsFeedDisplayLogic?
    let dateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "d MMM 'в' HH:mm"
        return dt
    }()
  
  func presentData(response: NewsFeed.Model.Response.ResponseType) {
      switch response {

      case .presentNewsFeed(feed: let feed):
          let cells = feed.items.map { feedItem in
              cellViewModel(from: feedItem, profiles: feed.profiles, groups: feed.groups)
          }
          let feedViewModel = FeedViewModel.init(cells: cells)
          viewController?.displayData(viewModel: .displayNewsFeed(feedViewModel: feedViewModel))
      }
  
}
    private func cellViewModel(from feedItem: FeedItem, profiles: [Profile], groups: [Group]) -> FeedViewModel.Cell {
        let profile = self.profile(for: feedItem.sourseId, profiles: profiles, groups: groups)
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormatter.string(from: date)
        return FeedViewModel.Cell.init(name: profile.name,
                                       date: dateTitle,
                                       text: feedItem.text,
                                       likes: String(feedItem.likes?.count ?? 0),
                                       comments: String(feedItem.comments?.count ?? 0),
                                       shares: String(feedItem.reposts?.count ?? 0),
                                       views: String(feedItem.views?.count ?? 0),
                                       iconUrlString: profile.photo)
    }
    
    private func profile(for sourseId: Int, profiles: [Profile], groups: [Group]) -> ProfileRep {
        let profilesOrGroups: [ProfileRep] = sourseId >= 0 ? profiles : groups
        let normalSourseId = sourseId >= 0 ? sourseId : -sourseId
        let profileRep = profilesOrGroups.first { myProfile -> Bool in
            myProfile.id == normalSourseId
        }
        return profileRep!
    }
}
