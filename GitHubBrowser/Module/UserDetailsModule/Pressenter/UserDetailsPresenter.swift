//
//  UserDetailsPresenter.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

class UserDetailsPresenter : UserDetailsPresentation {
   
   var user:User?
   
   var view: UserDetailsView?
   var router: UserDetailsWireframe?
   var interactor: UserDetailsUsecase?
   
   func viewDidLoad() {}
   func viewWillAppear(animated: Bool) {}
   func viewDidAppear(animated: Bool) {}
   func viewWillDisappear(animated: Bool) {}
   func viewDidDisappear(animated: Bool) {}
   
   //Interactor
   func downloadUserImage(from url:String, completion:@escaping (UIImage)->()) {
      interactor?.downloadUserImage(from: url, completion: { (image) in
         completion(image)
      })
   }
   
   //Router
   func goToWeb(url: URL) {
      router?.goToWeb(url: url)
   }
   
   func sendEmail(to address: String) {
      router?.sendEmail(to: address)
   }
}
