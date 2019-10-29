//
//  RepositoryTableViewCell.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
   
   static let CELL_IDENTIFIER = "RepositoryTableViewCell"
   
   var owner:User? {
      didSet {
         if let followers = owner?.followers {
            DispatchQueue.main.async {[weak self] in
               self?.folowersCountLabel.text = String(followers)
            }
         }
      }
   }
   
   var userImage:UIImage? {
      didSet {
         DispatchQueue.main.async {[weak self] in
            self?.userImageView.image = self?.userImage
         }
      }
   }
   
   weak var delegate:SearchViewProtocol?
   
   //MARK: IBOutlets
   @IBOutlet weak var userImageView: UIImageView!
   @IBOutlet weak var repositoryNameLabel: UILabel!
   @IBOutlet weak var userNameLabel: UILabel!
   @IBOutlet weak var folowersCountLabel: UILabel!
   @IBOutlet weak var forksCountLabel: UILabel!
   @IBOutlet weak var issuesCountLabel: UILabel!
   @IBOutlet weak var languageLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
   
   override func layoutSubviews() {
      super.layoutSubviews()
      
      userImageView.layer.cornerRadius = 12
      userImageView.layer.masksToBounds = true
   }
   
   override func prepareForReuse() {
      userImage = nil
      owner = nil
      userNameLabel.text = ""
      repositoryNameLabel.text = ""
      forksCountLabel.text = ""
      issuesCountLabel.text = ""
      languageLabel.text = ""
   }
   
   @IBAction func goToUserDetails(_ sender: UIButton) {
      if let user = owner {
         delegate?.goToUserDetails(user: user)
      }
   }
   
   public func configureCell(with repository: Repository) {
      userNameLabel.text = repository.owner?.login ?? ""
      repositoryNameLabel.text = repository.name
      forksCountLabel.text = "\(repository.forksCount ?? 0)"
      issuesCountLabel.text = "\(repository.openIssues ?? 0)"
      languageLabel.text = repository.language
   }
}
