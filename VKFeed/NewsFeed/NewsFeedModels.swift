//
//  NewsFeedModels.swift
//  VKFeed
//
//  Created by Артем Хребтов on 25.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum NewsFeed {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getNewsfeed
        case revealPostId(postId: Int)
        case getUser
        case getnextButch
      }
    }
    struct Response {
        enum ResponseType {
            case presentNewsFeed(feed: FeedResponse, revealedPostId: [Int])
            case presentUserInfo(user: UserResponse?)
      }
    }
    struct ViewModel {
      enum ViewModelData {
          case displayNewsFeed(feedViewModel: FeedViewModel)
          case displayUser(userViewModel: UserViewModel)
      }
    }
  }
  
}

struct UserViewModel: TitleViewViewModel {
    var photoxUrlString: String?
}
//Модель данных ячейки таблицы
struct FeedViewModel {
    struct Cell: FeedCellViewModel {
        var postId: Int
        var name: String
        var date: String
        var text: String?
        var likes: String?
        var comments: String?
        var shares: String?
        var views: String?
        var iconUrlString: String
        var photoAttachments: [FeedCellPhotoAttachmentViewModel]
        var sizes: FeedCellSizes
    }
    struct FeedCellPhotoAttachment: FeedCellPhotoAttachmentViewModel{
        var photoUrlString: String?
        var height: Int
        var width: Int
    }
    let cells: [Cell]
}
