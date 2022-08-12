//
//  CommentModel.swift
//  JourneyTest
//
//  Created by BigStep on 07/08/22.
//

import Foundation

struct CommentModel: Codable {
    let postID: Int
    let id: Int
    let name: String
    let email: String
    let body: String

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case id
        case name
        case email
        case body
    }
}

typealias Comment = [CommentModel]
