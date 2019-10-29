//
//  RepositoryWireframe.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation

protocol RepositoryWireframe {
    
    func goToWeb(url: URL)
    func goToUserDetails(user:User)
}
