//
//  RepositoryDetailsBuilder.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019. 
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

class RepositoryDetailsBuilder {
    
    static func assembleModule(repositoryDetails:Repository, owner:User? = nil) -> UIViewController? {
        let storyboard = UIStoryboard(name: Constant.MAIN_STORYBOARD_ID, bundle: nil)
        if let view = storyboard.instantiateViewController(withIdentifier: RepositoryDetailsVC.IDENTIFIER) as? RepositoryDetailsVC {
            let presenter = RepositoryPresenter()
            let interactor = RepositoryInteractor()
            let router = RepositoryRouter()
            
            presenter.repository = repositoryDetails
            presenter.ownerInfo = owner
            
            view.presenter = presenter
            presenter.view = view
            presenter.router = router
            presenter.interactor = interactor
            router.view = view
            interactor.presenter = presenter
            
            return view
        }else {
            return nil
        }
    }
}
