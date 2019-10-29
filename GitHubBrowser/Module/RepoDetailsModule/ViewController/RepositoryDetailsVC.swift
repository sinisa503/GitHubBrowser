//
//  RepositoryDetailsVC.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

class RepositoryDetailsVC: UIViewController {
   
   public static let IDENTIFIER = "RepositoryDetailsVC"
   
   @IBOutlet weak var descriptionLabel: UILabel!
   @IBOutlet weak var languageLabel: UILabel!
   @IBOutlet weak var lastUpdatedLabel: UILabel!
   @IBOutlet weak var creationDateLabel: UILabel!
   @IBOutlet weak var sizeLabel: UILabel!
   @IBOutlet weak var htmlUriButton: UIButton!
   @IBOutlet weak var issuesCountLabel: UILabel!
   @IBOutlet weak var ownerLabel: UILabel!
   @IBOutlet weak var isPrivateLabel: UILabel!
    @IBOutlet weak var saveButton: RoundedButton!
   
   var presenter:RepositoryPresenter?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let repository = presenter?.repository {
            configure(with: repository)
        }
        
        if let controllers = self.navigationController?.viewControllers {
            for controller in controllers {
                if let sVC = controller as? SearchVC, let source = sVC.searchSource {
                    switch source {
                    case .github:
                        saveButton(enable: true)
                    case .database:
                        saveButton(enable: false)
                    }
                }
            }
        }
    }
   
   @IBAction func goToWebUrl(_ sender: UIButton) {
      guard let repository = presenter?.repository, let urlString = repository.htmlUrl, let url = URL(string: urlString) else { return }
      presenter?.goToWeb(url: url)
   }
   
   @IBAction func goToOwnerDetails(_ sender: UIButton) {
      if let ownerInfo = presenter?.ownerInfo {
         presenter?.goToUserDetails(user: ownerInfo)
      }
   }
   
    @IBAction func saveRepositoryToDatabase(_ sender: UIButton) {
        if let repository = presenter?.repository, let appDelegate = UIApplication.shared.delegate as? AppDelegate {
           let dbService = DatabaseService()
            dbService.save(repository: repository, context: appDelegate.persistentContainer.viewContext) { result in
                switch result {
                case .success():
                    let okAction = UIAlertAction(title: Constant.OK, style: .default) { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                    showAlert(title: "Saved!", messagge: "You have saved this repository to database.", actions: [okAction])
                case .failure(let error):
                    showAlert(title: Constant.ERROR, messagge: error.localizedDescription)
                }
            }
        }
    }
    
    private func saveButton(enable: Bool) {
        saveButton.isHidden = !enable
        saveButton.isEnabled = enable
    }
    
   private func configure(with repository:Repository) {
      self.title = repository.name
    descriptionLabel.text = repository.description ?? Constant.NO_DESCRIPTION
      languageLabel.text = repository.language ?? NOT_AVAILABLE
      lastUpdatedLabel.text = repository.updatedAt?.formattedDate() ?? NOT_AVAILABLE
      creationDateLabel.text = repository.createdAt?.formattedDate() ?? NOT_AVAILABLE
      if let size = repository.size {
         sizeLabel.text = "\(size) \(MEGABYTES)"
      }else {
         sizeLabel.text = NOT_AVAILABLE
      }
      htmlUriButton.setTitle(repository.htmlUrl ?? NOT_AVAILABLE, for: .normal)
      if let openIssues = presenter?.repository?.openIssues {
         issuesCountLabel.text = "\(openIssues)"
      }else {
         issuesCountLabel.text = NOT_AVAILABLE
      }
      if let ownerName = repository.owner?.login {
         ownerLabel.text = ownerName
      }else {
         ownerLabel.text = NOT_AVAILABLE
      }
      if let isPrivate = repository.isPrivate {
         if isPrivate {
            isPrivateLabel.text = Constant.PRIVATE
         } else {
            isPrivateLabel.text = Constant.PUBLIC
         }
      }else {
         isPrivateLabel.text = NOT_AVAILABLE
      }
   }
}

extension RepositoryDetailsVC: RepositoryDetailsView {
   
}
