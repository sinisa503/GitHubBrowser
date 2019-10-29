//
//  UserDetailsBuilder.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

class UserDetailsBuilder {
    
    static func assembleModule(with user:User) -> UIViewController? {
        
        let storyboard = UIStoryboard(name: Constant.MAIN_STORYBOARD_ID, bundle: nil)
        if let view = storyboard.instantiateViewController(withIdentifier: UserDetailsVC.IDENTIFIER) as? UserDetailsVC {
            let presenter = UserDetailsPresenter()
            let interactor = UserDetailsInteractor()
            let router = UserDetailsRouter()
            
            presenter.user = user
            
            view.presenter = presenter
            presenter.view = view
            presenter.interactor = interactor
            presenter.router = router
            router.view = view
            interactor.presenter = presenter
            
            return view
        }else {
            return nil
        }
    }
}
