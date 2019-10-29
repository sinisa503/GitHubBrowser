//
//  RepositoryPresentation.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation

protocol RepositoryPresentation {
    
    func viewDidLoad()
    func viewWillAppear(animated: Bool)
    func viewDidAppear(animated: Bool)
    func viewWillDisappear(animated: Bool)
    func viewDidDisappear(animated: Bool)
    
    var ownerInfo:User? { get set }
    var repository:Repository? { get set }
    
    //Interactor
    func downloadUserInfo(username:String,completion:@escaping UserCompletion)
    
    //Router
    func goToWeb(url: URL)
    func goToUserDetails(user:User)
}
