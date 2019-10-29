//
//  ViewController.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchVC: UIViewController {

  public static let IDENTIFIER = "SearchVC"
  
   // MARK:  IBOutlets
   @IBOutlet weak var searchBar: UISearchBar!
   @IBOutlet weak var table: UITableView!
    
    
   var presenter: SearchPresentation?
   private let disposeBag = DisposeBag()
    var searchSource: Source?
    
   private var selectedRepository:(repository:Repository, owner:User?)? {
      didSet {
         if let tuple = selectedRepository {
            if let owner = selectedRepository?.owner {
               presenter?.showDetailsFor(repository: tuple.repository, owner: owner)
            }else {
               presenter?.showDetailsFor(repository: tuple.repository, owner: nil)
            }
         }
      }
   }
   
   // MARK:  Lifecycle
   override func viewDidLoad() {
      super.viewDidLoad()

      presenter?.viewDidLoad()
      setUpSearch()
      setUpTableView()
      setupNavigationBar()
   }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let source = self.searchSource, source == .database {
            presenter?.refreshData()
        }
    }
   
   private func setupNavigationBar() {
      self.navigationController?.isNavigationBarHidden = false
    self.navigationController?.navigationBar.topItem?.title = Constant.SEARCH_VC_TITLE
      
      let sortButtonItem = UIBarButtonItem(title: Constant.SORT_BUTTON_TITLE, style: .plain, target: self, action: #selector(sortButtonSelected))
      let orderButtonItem = UIBarButtonItem(title: Constant.ORDER_BUTTON_TITLE, style: .plain, target: self, action: #selector(orderButtonSelected))
      let currentUserButtonItem = UIBarButtonItem(title: Constant.USER_BUTTON_TITLE, style: .plain, target: self, action: #selector(showCurrentUserInfo))
      self.navigationController?.navigationBar.topItem?.rightBarButtonItems = [sortButtonItem, orderButtonItem]
      self.navigationController?.navigationBar.topItem?.leftBarButtonItems = [currentUserButtonItem]
   }
   
   @objc private func sortButtonSelected() {
      presentSortActionSheet()
   }
   
   @objc private func orderButtonSelected() {
      presentOrderActionSheet()
   }
   
   @objc private func showUserInfo() {
      presentOrderActionSheet()
   }
   
  @objc private func showCurrentUserInfo() {
    if let currentUser = CacheService.currentUser {
      presenter?.goToUserDetails(user: currentUser)
    } else {
      OAuthService.getAuthenticatedUser {[weak self] (user, error) in
        guard error == nil, let currentUser = user else {
            let okAction = UIAlertAction(title: Constant.OK, style: .default)
            self?.presenter?.showAlert(title: Constant.ERROR, messagge: error?.localizedDescription ?? "", actions: [okAction])
          return
        }
        self?.presenter?.goToUserDetails(user: currentUser)
      }
    }
  }
   
   private func presentSortActionSheet() {
      let actionSheet = UIAlertController(title: Constant.SORT_BUTTON_TITLE, message: Constant.SORT_OPTIONS_MESSAGE, preferredStyle: .actionSheet)
      actionSheet.addAction(UIAlertAction(title: Constant.ISSUES, style: .default, handler: {[weak self] _ in
         self?.presenter?.sort = .issues
         self?.dismiss(animated: true, completion: nil)
      }))
      actionSheet.addAction(UIAlertAction(title: Constant.FORKS, style: .default, handler: {[weak self] _ in
         self?.presenter?.sort = .forks
         self?.dismiss(animated: true, completion: nil)
      }))
      actionSheet.addAction(UIAlertAction(title: Constant.UPDATED, style: .default, handler: {[weak self] _ in
         self?.presenter?.sort = .updated
         self?.dismiss(animated: true, completion: nil)
      }))
      self.present(actionSheet, animated: true, completion: nil)
   }
   
   private func presentOrderActionSheet() {
      let actionSheet = UIAlertController(title: Constant.ORDER_BUTTON_TITLE, message: Constant.ORDER_OPTIONS_MESSAGE, preferredStyle: .actionSheet)
      actionSheet.addAction(UIAlertAction(title: Constant.ASCENDING, style: .default, handler: {[weak self] _ in
         self?.presenter?.order = .ascending
         self?.dismiss(animated: true, completion: nil)
      }))
      actionSheet.addAction(UIAlertAction(title: Constant.DESCENDING, style: .default, handler: {[weak self] _ in
         self?.presenter?.order = .descending
         self?.dismiss(animated: true, completion: nil)
      }))
      self.present(actionSheet, animated: true, completion: nil)
   }
   
   //MARK: TableView RX
    private func setUpTableView() {
        table.rx.didScroll.subscribe(onNext: { _ in
          self.view.endEditing(true)
        }).disposed(by: disposeBag)
        
        guard let repositories = presenter?.repositories else { return }
        
        repositories.asObservable().bind(to: table.rx
             .items(cellIdentifier: RepositoryTableViewCell.CELL_IDENTIFIER,
                    cellType: RepositoryTableViewCell.self)) { [unowned self] row, repository, cell in
                      if let repository = self.presenter?.repositories.value[row] {
                         cell.configureCell(with: repository)
                      }
                      if let imageUrl = self.presenter?.repositories.value[row].owner?.avatarUrl {
                         self.downloadUserImage(from: imageUrl) { (image) in
                            cell.userImage = image
                         }
                      }
                      if let username = self.presenter?.repositories.value[row].owner?.login {
                         self.downloadUserInfo(username: username) { (user) in
                            cell.owner = user
                         }
                      }
                      cell.delegate = self
             }.disposed(by: disposeBag)
        
        table.rx.modelSelected(Repository.self)
           .subscribe(onNext: { [unowned self] repository in
              if let selectedRowIndexPath = self.table.indexPathForSelectedRow {
                 if let repositoryTableViewCell = self.table.cellForRow(at: selectedRowIndexPath) as? RepositoryTableViewCell {
                    self.selectedRepository = (repository,repositoryTableViewCell.owner)
                 }
                 self.table.deselectRow(at: selectedRowIndexPath, animated: true)
              }
           })
           .disposed(by: disposeBag)
        
        
        switch self.searchSource! {
        case .github:
            break
            //setupTableForGitHubSearch()
        case .database:
            table.rx.modelDeleted(Repository.self)
                .subscribe(onNext: {[weak self] repository in
                    self?.presenter?.deleteFromDatabase(repository: repository)
                    self?.presenter?.refreshData()
            }).disposed(by: disposeBag)
        }
    }
    

   
   //MARK: SearchView RX
   private func setUpSearch() {
    if let source = searchSource {
        switch source {
        case .github:
                  searchBar.rx.searchButtonClicked.subscribe(onNext: { [unowned self] in
               if let searchString = self.searchBar.text {
                  if let params = [Api.QUERY_KEY:searchString, Api.SORT_KEY:self.presenter?.sort.rawValue, Api.ORDER_KEY:self.presenter?.order.rawValue] as? [String: String] {
                     self.browseGitHub(searchTerm:searchString , parametars: params)
                  }
               }
            }).disposed(by: disposeBag)
            
            searchBar
               .rx.text
               .orEmpty
               .subscribe(onNext: { [unowned self] text in
                  if text == "" {
                     self.presenter?.repositories.value = []
                  }
               })
               .disposed(by: disposeBag)
        case .database:
            searchBar.rx
                .text
                .orEmpty
                .subscribe(onNext: { [unowned self] text in
                    if text == "" {
                       self.presenter?.refreshData()
                    } else {
                        self.presenter?.repositories.value = self.presenter?.repositories.value.filter { ($0.name?.contains(text) ?? false) } ?? []
                    }
                }).disposed(by: disposeBag)
        }
    }
   }
   
  private func browseGitHub(searchTerm:String, parametars:[String:String]) {
    self.presenter?.browseGitHub(searchTerm: searchTerm, parametars: parametars).subscribe(onNext: { repositories in
      DispatchQueue.main.async {
          self.presenter?.repositories.value = repositories
      }
    }, onError: { error in
      DispatchQueue.main.async {
        self.showAlert(title: Constant.ERROR, messagge: error.localizedDescription)
      }
    }).disposed(by: self.disposeBag)
  }
   
   private func downloadUserInfo(username:String, completion:@escaping (User?)->()) {
      DispatchQueue.global().async(qos:.background) { [unowned self] in
        self.presenter?.downloadUserInfo(username: username).subscribe(onNext: { user in
          completion(user)
        }, onError: { error in
          self.showAlert(title: Constant.ERROR, messagge: error.localizedDescription)
        }).disposed(by: self.disposeBag)
      }
   }
   
   private func downloadUserImage(from url:String, completion:@escaping (UIImage)->()) {
      DispatchQueue.global().async(qos:.background) {
         self.presenter?.downloadUserImage(from: url, completion: { (image) in
            completion(image)
         })
      }
   }
   
   private func sortResults(order:Order) {
      presenter?.sortResults(order: order)
   }
   
   private func orderResults(sort: Sort) {
      presenter?.orderResults(sort: sort)
   }
}

// MARK:  SearchViewProtocol
extension SearchVC: SearchViewProtocol {
    func showAlert(title: String, messagge: String, actions: [UIAlertAction]) {
        self.showAlert(title: title, messagge: messagge, actions: actions)
    }
    
   func goToUserDetails(user: User) {
      self.presenter?.goToUserDetails(user: user)
   }
}
