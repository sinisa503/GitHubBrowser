//
//  UserDetailsRouter.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

class UserDetailsRouter: UserDetailsWireframe {
   var view:UserDetailsVC?
   
   func goToWeb(url: URL) {
      if UIApplication.shared.canOpenURL(url) {
         UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
   }
   
   func sendEmail(to address: String) {
      if let emailUrl = URL(string: "\(Constant.EMAIL_PREFIX)\(address)") {
         if UIApplication.shared.canOpenURL(emailUrl) {
            UIApplication.shared.open(emailUrl, options: [:], completionHandler: nil)
         }
      }
   }
}
