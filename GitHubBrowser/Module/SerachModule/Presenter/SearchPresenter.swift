//
//  SearchPresenter.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit
import RxSwift

enum Sort:String {
    case issues = "stars"
    case forks = "forks"
    case updated = "updated"
}

enum Order:String {
    case descending = "desc"
    case ascending = "asc"
}

class SearchPresenter: SearchPresentation {
    
    var repositories:Variable<[Repository]> = Variable<[Repository]>.init([])
    
    var sort:Sort = .forks {
        didSet {
            orderResults(sort: sort)
        }
    }
    var order:Order = .ascending {
        didSet {
            sortResults(order: order)
        }
    }
    
    var view: SearchViewProtocol?
    var router: SearchWireframe?
    var interactor: SearchUseCase?
    
    func viewDidLoad() {
        checkIfUserIsAuthenticated()
    }
    func viewWillAppear(animated: Bool) {}
    func viewDidAppear(animated: Bool) {}
    func viewWillDisappear(animated: Bool) {}
    func viewDidDisappear(animated: Bool) {}
    
    func browseGitHub(searchTerm:String,parametars:[String:String]) -> Observable<[Repository]> {
        guard let interactor = interactor else { return Observable.empty() }
        return interactor.browseGitHub(searchTerm: searchTerm, parametars: parametars)
    }
    
    func downloadUserInfo(username:String) -> Observable<User> {
        return interactor?.downloadUserInfo(username: username) ?? Observable.empty()
    }
    
    func downloadUserImage(from url:String, completion:@escaping (UIImage)->()) {
        interactor?.downloadUserImage(from: url, completion: { (image) in
            completion(image)
        })
    }
    
    func showAlert(title:String, messagge:String, actions: [UIAlertAction]) {
        self.view?.showAlert(title: title, messagge: messagge, actions: actions)
    }
    
    func showDetailsFor(repository:Repository, owner:User?) {
        router?.showDetailsFor(repository: repository, owner: owner)
    }
    
    func goToUserDetails(user:User) {
        router?.goToUserDetails(user: user)
    }
    
    private func checkIfUserIsAuthenticated() {
        if OAuthService.OAuthToken == nil {
            OAuthService.startOAuth2Login()
        }
    }
    
    func refreshData() {
        self.interactor?.refreshData()
    }
    
    func deleteFromDatabase(repository: Repository) {
        self.interactor?.deleteFromDatabase(repository: repository)
    }
    
    func sortResults(order:Order) {
        if repositories.value.count > 0 {
            switch sort {
                
            case .forks:
                switch order {
                case .ascending:
                    repositories.value = repositories.value.sorted {
                        guard $0.forksCount != nil, $1.forksCount != nil else { return false }
                        return $0.forksCount! < $1.forksCount!
                    }
                case .descending:
                    repositories.value = repositories.value.sorted {
                        guard $0.forksCount != nil, $1.forksCount != nil else { return false }
                        return $0.forksCount! > $1.forksCount!
                    }
                }
            case .updated:
                switch order {
                case .ascending:
                    repositories.value = repositories.value.sorted {
                        guard $0.updatedAt?.dateRepresentation() != nil, $1.updatedAt?.dateRepresentation() != nil else { return false }
                        return ($0.updatedAt?.dateRepresentation())! < ($1.updatedAt?.dateRepresentation())!
                    }
                case .descending:
                    repositories.value = repositories.value.sorted {
                        guard $0.updatedAt?.dateRepresentation() != nil, $1.updatedAt?.dateRepresentation() != nil else { return false }
                        return ($0.updatedAt?.dateRepresentation())! > ($1.updatedAt?.dateRepresentation())!
                    }
                }
                
            //No api response for stars count??? Sorting is made by issues...
            case .issues:
                switch order {
                case .ascending:
                    repositories.value = repositories.value.sorted {
                        guard $0.issuesCount != nil, $1.issuesCount != nil else { return false }
                        return $0.issuesCount! < $1.issuesCount!
                    }
                case .descending:
                    repositories.value = repositories.value.sorted {
                        guard $0.issuesCount != nil, $1.issuesCount != nil else { return false }
                        return $0.issuesCount! > $1.issuesCount!
                    }
                }
            }
        }
    }
    
    func orderResults(sort: Sort) {
        switch order {
        case .ascending:
            switch sort {
            case .forks:
                repositories.value = repositories.value.sorted {
                    guard $0.forksCount != nil, $1.forksCount != nil else { return false }
                    return $0.forksCount! < $1.forksCount!
                }
            case .issues:
                repositories.value = repositories.value.sorted {
                    guard $0.issuesCount != nil, $1.issuesCount != nil else { return false }
                    return $0.issuesCount! < $1.issuesCount!
                }
            case .updated:
                repositories.value = repositories.value.sorted {
                    guard $0.updatedAt?.dateRepresentation() != nil, $1.updatedAt?.dateRepresentation() != nil else { return false }
                    return ($0.updatedAt?.dateRepresentation())! < ($1.updatedAt?.dateRepresentation())!
                }
            }
        case .descending:
            switch sort {
            case .forks:
                repositories.value = repositories.value.sorted {
                    guard $0.forksCount != nil, $1.forksCount != nil else { return false }
                    return $0.forksCount! > $1.forksCount!
                }
            case .issues:
                repositories.value = repositories.value.sorted {
                    guard $0.issuesCount != nil, $1.issuesCount != nil else { return false }
                    return $0.issuesCount! > $1.issuesCount!
                }
            case .updated:
                repositories.value = repositories.value.sorted {
                    guard $0.updatedAt?.dateRepresentation() != nil, $1.updatedAt?.dateRepresentation() != nil else { return false }
                    return ($0.updatedAt?.dateRepresentation())! > ($1.updatedAt?.dateRepresentation())!
                }
            }
        }
    }
}
