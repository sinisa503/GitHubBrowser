//
//  RepositoryRouter.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

class RepositoryRouter: RepositoryWireframe {
   
   var view: RepositoryDetailsVC?
   
   func goToWeb(url: URL) {
      if UIApplication.shared.canOpenURL(url) {
         UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
   }
   
   func goToUserDetails(user:User) {
      if let userDetailsVC = UserDetailsBuilder.assembleModule(with: user) as? UserDetailsVC {
         view?.navigationController?.navigationBar.topItem?.title = ""
         view?.navigationController?.show(userDetailsVC, sender: nil)
      }
   }
}
