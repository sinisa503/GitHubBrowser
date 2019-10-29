//
//  UserDetailsInteractor.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

class UserDetailsInteractor: UserDetailsUsecase {
   
   var presenter: UserDetailsPresentation?
   
   func downloadUserImage(from url:String, completion:@escaping (UIImage)->()) {
      DownloadService.getImage(from: url) {downloadOption in
         switch downloadOption {
         case .success(let image):
            completion(image)
         case .failure(_):
            break
         }
      }
   }
}
