//
//  NetworkHelper.swift
//  JourneyTest
//
//  Created by BigStep on 07/08/22.
//

import Foundation

enum AppError: Error {
    case badURL(String)
    case networkError(Error)
    case noResponse
    case decodingError(Error)
    
    public func errorMessage() -> String {
        switch self {
        case .badURL(let str):
            return "badURL: \(str)"
        case .networkError(let error):
            return "networkError: \(error)"
        case .noResponse:
            return "no network response"
        case .decodingError(let error):
            return "decoding error: \(error)"
        }
    }
}

final class NetworkHelper {
    static var baseURL = "https://jsonplaceholder.typicode.com/"
    
    static func performDataTask(urlString: String,
                                httpMethod: String,
                                completionHandler: @escaping (AppError?, Data?, HTTPURLResponse?) ->Void) {
        guard let url = URL(string: "\(baseURL)\(urlString)") else {
            completionHandler(AppError.badURL("\(urlString)"), nil, nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                completionHandler(AppError.noResponse, nil, nil)
                return
            }
            
            if let error = error {
                completionHandler(AppError.networkError(error), nil, response)
            } else if let data = data {
                completionHandler(nil, data, response)
            }
        }.resume()
    }
}
