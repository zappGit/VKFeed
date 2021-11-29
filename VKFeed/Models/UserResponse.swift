//
//  UserResponse.swift
//  VKFeed
//
//  Created by Артем Хребтов on 29.11.2021.
//

import Foundation

struct UserResponseWrapted: Codable {
    let response: [UserResponse]
}

struct UserResponse: Codable {
    let photo100: String
    enum CodingKeys: String, CodingKey {
        case photo100 = "photo_100"
    }
}

