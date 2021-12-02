//
//  NewsFeedWorker.swift
//  VKFeed
//
//  Created by Артем Хребтов on 25.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class NewsFeedService {

    var authServise: AuthService
    var networking: Networking
    var fetcher: DataFetcher
    
    
    private var revealedPostId = [Int]()
    private var feedResponse: FeedResponse?
    private var newForm: String?
    
    init() {
        self.authServise = SceneDelegate.shared().authService
        self.networking = NetworkService(auth: authServise)
        self.fetcher = NetworkDataFetcher(networking: networking)
    }
    
    func getUser(response: @escaping (UserResponse?) -> Void) {
        fetcher.getUser { user in
            response(user)
        }
    }
    
    func getFeed(response: @escaping ([Int], FeedResponse) -> Void) {
        fetcher.getFeed(nextButchFrom: nil) {[weak self] feed in
            self?.feedResponse = feed
            guard let feedRes = self?.feedResponse else {return}
            response(self!.revealedPostId, feedRes)
        }
    }
    
    func revealPostIds(forPostId postId: Int, response: @escaping ([Int], FeedResponse) -> Void) {
        revealedPostId.append(postId)
        guard let feedResponse = feedResponse else {
            return
        }
        response(revealedPostId, feedResponse)
    }
    
    func getNextButch(complition: @escaping ([Int], FeedResponse) -> Void) {
        newForm = feedResponse?.nextFrom
        fetcher.getFeed(nextButchFrom: newForm) {[weak self] feed in
            guard let feed = feed else { return }
            guard self?.feedResponse?.nextFrom != feed.nextFrom else { return }
            
            if self?.feedResponse == nil {
                self?.feedResponse = feed
            } else {
                //добавляем все новые записи к уже полученным
                self?.feedResponse?.items.append(contentsOf: feed.items)
                
                var profiles = feed.profiles
                if let oldProfiles = self?.feedResponse?.profiles {
                    //в массив записываем те профили которых еще не было в старом массиве профилей
                    let oldFilteredProfiles = oldProfiles.filter { old in
                        //сравниваем текущий профиль со старыми и если не равно то добавляем в массив
                        !feed.profiles.contains(where: { $0.id == old.id })
                    }
                    profiles.append(contentsOf: oldFilteredProfiles)
                }
                self?.feedResponse?.profiles = profiles
                var groups = feed.groups
                if let oldGroups = self?.feedResponse?.groups {
                    //в массив записываем те профили которых еще не было в старом массиве профилей
                    let oldFilteredGroups = oldGroups.filter { old in
                        //сравниваем текущий профиль со старыми и если не равно то добавляем в массив
                        !feed.groups.contains(where: { $0.id == old.id })
                    }
                    groups.append(contentsOf: oldFilteredGroups)
                }
                self?.feedResponse?.groups = groups
                self?.feedResponse?.nextFrom = feed.nextFrom
                
            }
            guard let feedResponse = self?.feedResponse else {
                return
            }

            complition(self!.revealedPostId, feedResponse)
        }
    }
}
