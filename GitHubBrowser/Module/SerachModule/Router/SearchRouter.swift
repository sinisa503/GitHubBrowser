//
//  SearchRouter.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation

class SearchRouter: SearchWireframe {
   
   var view: SearchVC?
   
   
   func showDetailsFor(repository:Repository, owner:User?) {
      if let repositoryDetails = RepositoryDetailsBuilder.assembleModule(repositoryDetails: repository, owner: owner) as? RepositoryDetailsVC {
         view?.navigationController?.navigationBar.topItem?.title = ""
         view?.show(repositoryDetails, sender: self)
      }
   }
   
   func goToUserDetails(user:User) {
      if let userDetailsVC = UserDetailsBuilder.assembleModule(with: user) as? UserDetailsVC {
         view?.navigationController?.navigationBar.topItem?.title = ""
         view?.navigationController?.show(userDetailsVC, sender: nil)
      }
   }
}
