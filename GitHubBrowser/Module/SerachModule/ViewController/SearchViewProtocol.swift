//
//  SearchView.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

protocol SearchViewProtocol: class {
   func goToUserDetails(user:User)
    func showAlert(title:String, messagge:String, actions: [UIAlertAction])
}
