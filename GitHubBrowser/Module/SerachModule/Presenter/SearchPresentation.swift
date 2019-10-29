//
//  SearchPresentation.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit
import RxSwift

protocol SearchPresentation:class {
   
   func viewDidLoad()
   func viewWillAppear(animated: Bool)
   func viewDidAppear(animated: Bool)
   func viewWillDisappear(animated: Bool)
   func viewDidDisappear(animated: Bool)
   
   func sortResults(order:Order)
   func orderResults(sort: Sort)
   
   var repositories:Variable<[Repository]> { get set }
   
   var sort:Sort { get set }
   var order:Order { get set }

   //Interactor
   func browseGitHub(searchTerm:String,parametars:[String:String]) -> Observable<[Repository]>
   func downloadUserInfo(username:String) -> Observable<User>
   func downloadUserImage(from url:String, completion:@escaping (UIImage)->())
    func refreshData()
    func deleteFromDatabase(repository: Repository)

   //Router
   func showDetailsFor(repository:Repository, owner:User?)
   func goToUserDetails(user:User)
   //View
    func showAlert(title:String, messagge:String, actions: [UIAlertAction])
}
