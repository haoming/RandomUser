//
//  UserFetcher.swift
//  RandomUser
//
//  Created by Haoming Ma on 14/11/19.
//  Copyright © 2019 Haoming. All rights reserved.
//

import Foundation
import Combine

enum RandomUserError: Error, Equatable {
  case parsing(description: String)
  case network(description: String)
}

public class UserFetcher {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    static func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, RandomUserError> {
        
        if let str = String(data: data, encoding: .utf8) {
            print(str)
        }
        
        return Just(data)
          .decode(type: T.self, decoder: JSONDecoder())
          .mapError { error in
            print("print error:")
            print(error)
            return .parsing(description: error.localizedDescription)
          }
          .eraseToAnyPublisher()
    }
    
    func getUsers(page: Int, count: Int, seed: String, gender: String? = nil, nationality: String? = nil) -> AnyPublisher<RandomUserApiResponse, RandomUserError> {
        let url = getQueryURLComponents(page: page, count: count, seed: seed, gender: gender, nationality: nationality)
        return fetch(urlComponents: url)
    }
    
    private func fetch<T>(urlComponents: URLComponents) -> AnyPublisher<T, RandomUserError> where T: Decodable {
      guard let url = urlComponents.url else {
        let error = RandomUserError.network(description: "Couldn't create URL")
        return Fail(error: error).eraseToAnyPublisher()
      }
      return urlSession.dataTaskPublisher(for: URLRequest(url: url))
        .mapError { error in
          .network(description: error.localizedDescription)
        }
        .flatMap(maxPublishers: .max(1)) { pair in
            UserFetcher.decode(pair.data)
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - RandomUser APIs
private extension UserFetcher {
  struct RandomUserAPI {
    static let scheme = "https"
    static let host = "randomuser.me"
    static let path = "/api/1.3/"
  }
  
  func getQueryURLComponents(page: Int, count: Int, seed: String, gender: String? = nil, nationality: String? = nil) -> URLComponents {
    var components = URLComponents()
    components.scheme = RandomUserAPI.scheme
    components.host = RandomUserAPI.host
    components.path = RandomUserAPI.path
    
    var queryItems = [
      URLQueryItem(name: "page", value: "\(page)"),
      URLQueryItem(name: "results", value: "\(count)"),
      URLQueryItem(name: "seed", value: seed)
    ]
    if let gender = gender {
        queryItems.append(URLQueryItem(name: "gender", value: gender))
    }
    if let nationality = nationality {
        queryItems.append(URLQueryItem(name: "nat", value: nationality))
    }
    components.queryItems = queryItems
    return components
  }
}
