//
//  PostModel.swift
//  JourneyTest
//
//  Created by BigStep on 07/08/22.
//

import Foundation

struct PostModel: Codable {
    let userID: Int
    let id: Int
    let title: String
    let body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id
        case title
        case body
    }
}

typealias Post = [PostModel]
