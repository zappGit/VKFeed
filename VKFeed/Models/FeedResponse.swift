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
    var profiles: [Profile]
    var groups: [Group]
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
    let attachments: [Attachment]?
    
    enum CodingKeys: String, CodingKey {
        case sourseId = "source_id"
        case postId = "post_id"
        case text, date, comments, likes, reposts, views, attachments
    }
}

struct CountableItems: Codable {
    let count: Int
}

protocol ProfileRep {
    var id: Int { get }
    var name: String { get }
    var photo: String { get }
    
}
struct Profile: Codable, ProfileRep {
    var name: String { return firstName + " " + lastName }
    var photo: String { return photo100}
    
    let id: Int
    let firstName: String
    let lastName: String
    let photo100: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo100 = "photo_100"
    }
}

struct Group: Codable, ProfileRep {
    
    let id: Int
    let name: String
    let photo100: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case photo100 = "photo_100"
    }
    
    var photo: String { return photo100 }
}


struct Attachment: Codable {
    let photo: Photo?
}

struct Photo: Codable{
    let sizes: [PhotoSize]
    var height: Int {
        return getPropperSize().height
    }
    var width: Int {
        return getPropperSize().width
    }
    
    var srcBig: String {
        return getPropperSize().url
    }
    
    private func getPropperSize() -> PhotoSize{
        if let sizeX = sizes.first(where: { $0.type == "x"}) {
            return sizeX
        } else if let fallBackSize = sizes.last {
            return fallBackSize
        } else {
            return PhotoSize(type: "wrong image", url: "wrong image", width: 0, height: 0)
        }
    }
}

struct PhotoSize: Codable {
    let type: String
    let url: String
    let width: Int
    let height: Int
}
