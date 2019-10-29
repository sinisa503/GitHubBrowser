//
//  GitHubService.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation
import RxSwift


enum GitHubError:Error {
  case rateLimitExceeded
  case zeroCount
  case downloadError
  case noAccessToken
}

typealias RepositoryCompletion = ([Repository]?,Error?) -> ()
typealias UserCompletion = (User?,Error?) -> ()

class GitHubService {
  
  private static var repoOwnerInfo:[Int:User] = [:]
  private static let disposeBag = DisposeBag()
  
  static func getGitHubUser(username:String) -> Observable<User> {
    return Observable<User>.create { observer -> Disposable in
      let searchGitHubUserEndpoint = "\(Api.USERS_ENDPOINT)\(username)"
      NetworkingService.performRequest(resource: User.self, endpoint: searchGitHubUserEndpoint) { result in
        switch result {
        case .success(let user):
          observer.onNext(user)
        case .failure(let error):
          observer.onError(error)
        }
      }
      return Disposables.create()
    }
  }
  
  static func browseGitHub(searchTerm:String, parametars:[String:String]) -> Observable<[Repository]> {
    Observable.create { observer -> Disposable in
      NetworkingService.performRequest(resource: JsonResponse.self, endpoint: Api.REPOSITORIES_ENDPOINT, parameters: parametars) { result in
        switch result {
        case .success(let jsonResponse):
          if let repositories = jsonResponse.repositories {
            observer.onNext(repositories)
          } else {
            observer.onCompleted()
          }
        case .failure(let error):
          observer.onError(error)
        }
      }
      return Disposables.create()
    }
  }
}
