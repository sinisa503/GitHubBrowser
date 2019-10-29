//
//  UserDetailsWireframe.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

protocol UserDetailsUsecase: class {
   
   func downloadUserImage(from url:String, completion:@escaping (UIImage)->())
}
