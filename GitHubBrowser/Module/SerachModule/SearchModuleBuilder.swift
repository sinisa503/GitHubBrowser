//
//  SearchModuleBuilder.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

enum Source {
    case github
    case database
}

class SearchModuleBuilder {
    
    static func assembleModule(source: Source) -> UIViewController? {
        let storyboard = UIStoryboard(name: Constant.MAIN_STORYBOARD_ID, bundle: nil)
        if let view = storyboard.instantiateViewController(withIdentifier: SearchVC.IDENTIFIER) as? SearchVC {
            let presenter = SearchPresenter()
            let interactor = SearchInteractor()
            let router = SearchRouter()
            
            view.presenter = presenter
            presenter.view = view
            presenter.router = router
            presenter.interactor = interactor
            router.view = view
            interactor.presenter = presenter
            
            view.searchSource = source
            return view
        }else {
            return nil
        }
    }
}
