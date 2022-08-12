//
//  PostAPIClient.swift
//  JourneyTest
//
//  Created by BigStep on 07/08/22.
//

import Foundation

protocol APIClientProtocol: AnyObject {
    func getPosts(completion: @escaping (Post?, AppError?) -> Void)
    func getComment(postID: String, completion: @escaping (Comment?, AppError?) -> Void)
}

class APIClient: APIClientProtocol {
    
    func getPosts(completion: @escaping (Post?, AppError?) -> Void) {
        NetworkHelper.performDataTask(urlString: "posts",
                                      httpMethod: "GET") { networkError, data, response in
            guard let error = networkError else {
                guard response?.statusCode == 200 else {
                    completion(nil , AppError.noResponse)
                    return
                }
                
                let jsonDecoder = JSONDecoder()
                do {
                    let post = try jsonDecoder.decode(Post.self, from: data ?? Data())
                    
                    completion(post, nil)
                    return
                } catch {
                    completion(nil , AppError.noResponse)
                }
                
                return
            }
           
            completion(nil, error)
            
        }
    }
    
    func getComment(postID: String, completion: @escaping (Comment?, AppError?) -> Void) {
        NetworkHelper.performDataTask(urlString: "posts/\(postID)/comments",
                                      httpMethod: "GET") { networkError, data, response in
            guard let error = networkError else {
                guard response?.statusCode == 200 else {
                    completion(nil , AppError.noResponse)
                    return
                }
                
                let jsonDecoder = JSONDecoder()
                do {
                    let comment = try jsonDecoder.decode(Comment.self, from: data ?? Data())
                    
                    completion(comment, nil)
                    return
                } catch {
                    completion(nil , AppError.noResponse)
                }
                
                return
            }
            
            completion(nil, error)
        }
    }
    
}
