//
//  UserDetailsVC.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

class UserDetailsVC: UIViewController,UserDetailsView {
    
    public static let IDENTIFIER = "UserDetailsVC"
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var publicReposLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var sendEmailButton: RoundedButton!
    @IBOutlet weak var moreInfoButton: RoundedButton!
    
    @IBAction func sendEmail(_ sender: RoundedButton) {
        if let emailAddress = presenter?.user?.email {
            presenter?.sendEmail(to: emailAddress)
        }
    }
    
    @IBAction func moreInfo(_ sender: RoundedButton) {
        if let userUrl = presenter?.user?.htmlUrl, let url = URL(string: userUrl) {
            presenter?.goToWeb(url: url)
        }
    }
    
    weak var presenter:UserDetailsPresentation?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = presenter?.user {
            cofigure(with: user)
        }
    }
    
    private func cofigure(with user: User) {
        self.title = user.login ?? NOT_AVAILABLE
        fullNameLabel.text = user.name ?? NOT_AVAILABLE
        companyLabel.text = user.company ?? NOT_AVAILABLE
        lastUpdateLabel.text = user.updatedAt?.formattedDate() ?? NOT_AVAILABLE
        if let publicReposCount = user.publicRepos {
            publicReposLabel.text = String(publicReposCount)
        }
        if let followersCount = user.followers {
            followersLabel.text = String(followersCount)
        }
        if let followingCount = user.following {
            followingLabel.text = String(followingCount)
        }
        
        if let imageUrl = user.avatarUrl {
            downloadUserImage(from: imageUrl) {[weak self] (image) in
                self?.userImage.image = image
            }
        }else {
            userImage.image = #imageLiteral(resourceName: "username_icon")
        }
        
        if user.email == nil {
            dissableEmailButton()
        }
        if user.htmlUrl == nil {
            dissableMoreInfoButton()
        }
    }
    
    private func dissableEmailButton() {
        sendEmailButton.isEnabled = false
        sendEmailButton.backgroundColor = UIColor.lightGray
        sendEmailButton.alpha = 0.5
    }
    private func dissableMoreInfoButton() {
        moreInfoButton.isEnabled = false
        moreInfoButton.backgroundColor = UIColor.lightGray
        moreInfoButton.alpha = 0.5
    }
    
    private func downloadUserImage(from url:String, completion:@escaping (UIImage)->()) {
        DispatchQueue.global().async(qos:.background) {
            self.presenter?.downloadUserImage(from: url, completion: { (image) in
                DispatchQueue.main.async {
                    completion(image)
                }
            })
        }
    }
}


