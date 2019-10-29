//
//  RepositoryRouter.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

class RepositoryRouter: RepositoryWireframe {
    
    var view: RepositoryDetailsVC?
    
    func goToWeb(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
    }
    
    func goToUserDetails(user:User) {
        if let userDetailsVC = UserDetailsBuilder.assembleModule(with: user) as? UserDetailsVC {
            view?.navigationController?.navigationBar.topItem?.title = ""
            view?.navigationController?.show(userDetailsVC, sender: nil)
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
