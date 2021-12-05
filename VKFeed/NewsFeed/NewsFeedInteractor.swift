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

    func makeRequest(request: NewsFeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsFeedService()
        }
        switch request {
            
        case .getNewsfeed:
            service?.getFeed(response: {[weak self] (revealPostId, feed) in
                self?.presenter?.presentData(response: .presentNewsFeed(feed: feed, revealedPostId: revealPostId))
            })
        case .revealPostId(postId: let postId):
            service?.revealPostIds(forPostId: postId, response: { [weak self] revealPostId, feed in
                self?.presenter?.presentData(response: .presentNewsFeed(feed: feed, revealedPostId: revealPostId))
            })
        case .getUser:
            service?.getUser(response: { [weak self] user in
                self?.presenter?.presentData(response: .presentUserInfo(user: user))
            })
        case .getnextButch:
            self.presenter?.presentData(response: .presentFooterLoader)
            service?.getNextButch(complition: { [weak self] revealPostId, feed in
                self?.presenter?.presentData(response: .presentNewsFeed(feed: feed, revealedPostId: revealPostId))
            })
        }
    }
}
