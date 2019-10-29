//
//  UserDetailsPresentation.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

protocol UserDetailsPresentation:class {
   
   func viewDidLoad()
   func viewWillAppear(animated: Bool)
   func viewDidAppear(animated: Bool)
   func viewWillDisappear(animated: Bool)
   func viewDidDisappear(animated: Bool)
   
   var user:User? { get set }
   
   //Interactor
   func downloadUserImage(from url:String, completion:@escaping (UIImage)->())
   
   //Router
   func goToWeb(url: URL)
   func sendEmail(to address:String)
}
