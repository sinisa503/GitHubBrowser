//
//  SearchUseCase.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit
import RxSwift

protocol SearchUseCase: class {
    
    func browseGitHub(searchTerm:String,parametars:[String:String]) -> Observable<[Repository]>
    func downloadUserInfo(username:String) -> Observable<User>
    func downloadUserImage(from url:String, completion:@escaping (UIImage)->())
    func refreshData()
    func deleteFromDatabase(repository: Repository)
}
