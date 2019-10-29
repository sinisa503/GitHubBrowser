//
//  NetworkingService.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2019 Sinisa Vukovic. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkError:Error {
  case downloadError
  case noNetworkError
  case genericError
}

class NetworkingService {
  
  
  private static let BEARER = "Bearer"
  private static let AUTHORIZATION = "Authorization"
  private static let CONTENT_TYPE = "Content-Type"
  private static let APPLICATION_JSON = "application/json"
  

  static func performRequest<T>(resource: T.Type,
                                baseUrl:String? = Api.BASE_URL,
                                endpoint: String,
                                httpMethod: HTTPMethod? = .get,
                                parameters: Parameters? = nil,
                                completion: @escaping (Result<T>) -> ()) where T:Decodable {
    
    guard var reqUrl = URL(string: baseUrl!), let accessToken = OAuthService.OAuthToken else { return }
    reqUrl.appendPathComponent(endpoint)
    let headers: HTTPHeaders = [AUTHORIZATION:"\(BEARER) \(accessToken)", CONTENT_TYPE:APPLICATION_JSON]
    
    Alamofire.request(reqUrl, method: httpMethod!, parameters: parameters, headers: headers).validate().responseJSON { response in
      guard response.error == nil, let data = response.data else { completion(.failure(response.error!)) ; return }
      do {
        let responseObject = try JSONDecoder().decode(T.self, from: data)
        completion(.success(responseObject))
      } catch let error {
        completion(.failure(error))
      }
    }
  }
}
