//
//  ViewController+Ext.swift
//  GitHubBrowser
//
//  Created by Home on 28/10/2019.
//  Copyright © 2019 Sinisa Vukovic. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title:String, messagge:String, actions:[UIAlertAction]? = nil) {
       let alert = UIAlertController(title: title, message: messagge, preferredStyle: .alert)
        if let actions = actions {
            for action in actions {
                alert.addAction(action)
            }
        }
       self.present(alert, animated: true, completion: nil)
    }
}
