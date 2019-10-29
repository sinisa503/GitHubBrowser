//
//  SearchInteractor.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit
import RxSwift

class SearchInteractor: SearchUseCase {
    
    private let dbService = DatabaseService()
  
  func browseGitHub(searchTerm:String,parametars:[String:String]) -> Observable<[Repository]> {
    return GitHubService.browseGitHub(searchTerm: searchTerm, parametars: parametars)
  }
  
  func downloadUserImage(from url:String, completion:@escaping (UIImage)->()) {
    DownloadService.getImage(from: url) {downloadOption in
      switch downloadOption {
      case .success(let image):
        completion(image)
      case .failure(_):
        completion(#imageLiteral(resourceName: "username_icon"))
      }
    }
  }
  
  func downloadUserInfo(username:String) -> Observable<User> {
    return GitHubService.getGitHubUser(username: username)
  }
    
    func refreshData() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            dbService.fetchAllStoredRepositories(context: context) { result in
                switch result {
                case .success(let savedRepos):
                    if savedRepos.count > 0 {
                        var repositories:[Repository] = []
                        for repoEntity in savedRepos {
                            repositories.append(Repository(entity: repoEntity))
                        }
                        presenter?.repositories.value = repositories
                    }
                case .failure(let error):
                    //showAlert(title: Constant.ERROR, messagge: error.localizedDescription)
                    break
                }
            }
        }
    }
    
    func deleteFromDatabase(repository: Repository) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let name = repository.name {
            let context = appDelegate.persistentContainer.viewContext
            dbService.deleteRepository(with: name, context: context) { result in
                switch result {
                case .success():
                    let okAction = UIAlertAction(title: Constant.OK, style: .default)
                    //showAlert(title: "Success", messagge: "You have deleted repository from database", actions:[okAction])
                case .failure(let error):
                    //showAlert(title: Constant.ERROR, messagge: error.localizedDescription)
                    break
                }
            }
        }
    }
  
  weak var presenter: SearchPresentation?
}
