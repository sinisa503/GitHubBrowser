//
//  SearchWireframe.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation

protocol SearchWireframe: class {
    
    func showDetailsFor(repository:Repository, owner:User?)
    func goToUserDetails(user:User)
}
