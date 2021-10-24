//
//  Models.swift
//  VKFeed
//
//  Created by Артем Хребтов on 24.10.2021.
//

import Foundation

struct FeedResponseWrapped: Codable {
    let response: FeedResponse
}

struct FeedResponse: Codable {
    var items: [FeedItem]
}

struct FeedItem: Codable {
    
    let sourseId: Int
    let postId: Int
    let text: String?
    let date: Double
    let comments: CountableItems?
    let likes: CountableItems?
    let reposts: CountableItems?
    let views: CountableItems?
    
    enum CodingKeys: String, CodingKey {
            case sourseId = "source_id"
            case postId = "post_id"
            case text, date, comments, likes, reposts, views
    }
}

struct CountableItems: Codable {
    let count: Int
}
