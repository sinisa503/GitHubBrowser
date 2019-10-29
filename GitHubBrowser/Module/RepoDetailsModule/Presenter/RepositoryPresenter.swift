//
//  RepositoryPresenter.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation

class RepositoryPresenter: RepositoryPresentation {
   
   var ownerInfo: User?
   var repository: Repository?
   
   var view: RepositoryDetailsView?
   var router: RepositoryWireframe?
   var interactor: RepositoryUseCase?
   
   func viewDidLoad() {}
   func viewWillAppear(animated: Bool) {}
   func viewDidAppear(animated: Bool) {}
   func viewWillDisappear(animated: Bool) {}
   func viewDidDisappear(animated: Bool) {}
   
   func downloadUserInfo(username:String,completion:@escaping UserCompletion) {
      interactor?.downloadUserInfo(username: username, completion: { (user, error) in
         completion(user,error)
      })
   }
   
   func goToWeb(url: URL) {
      router?.goToWeb(url: url)
   }
   
   func goToUserDetails(user:User) {
      router?.goToUserDetails(user: user)
   }
}
