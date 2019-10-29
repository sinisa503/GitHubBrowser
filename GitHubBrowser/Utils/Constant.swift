//
//  Constant.swift
//  GitHubBrowser
//
//  Created by Siniša on 22/10/2019.
//  Copyright © 2019 Sinisa Vukovic. All rights reserved.
//

import Foundation

import Foundation

let NOT_AVAILABLE = "N/A"
let MEGABYTES = "MB"

struct Constant {
  // Storyboard identifiers
  static let MAIN_STORYBOARD_ID = "Main"
  
  static let ERROR = "Error"
  static let EMAIL_PREFIX = "mailto:"
  static let EQUALS = Character("=")
  static let AMPERSAND = Character("&")
  
  //MARK: SearchVC Constants
  static let SEARCH_VC_TITLE = "Github browser"
  static let SORT_BUTTON_TITLE = "Sort"
  static let ORDER_BUTTON_TITLE = "Order"
  static let USER_BUTTON_TITLE = "User"
  static let OK = "OK"
  static let ORDER_OPTIONS_TITLE = "Order options"
  static let ORDER_OPTIONS_MESSAGE = "Select one of the order options"
  static let ASCENDING = "Ascending"
  static let DESCENDING = "Descending"
  static let SORT_OPTIONS_TITLE = "Sort options"
  static let SORT_OPTIONS_MESSAGE = "Select one of the sort options"
  static let STARS = "Stars"
  static let FORKS = "Forks"
  static let ISSUES = "Issues"
  static let UPDATED = "Updated"
  static let SECTION_COUNT = 1
  
  //MARK: RepositoryDetailsVC Constants
  static let PRIVATE = "Private"
  static let PUBLIC = "Public"
  static let NO_DESCRIPTION = "No description"
}

struct Api {
  
  static let BASE_URL = "https://api.github.com"
  static let GITHUB_URL = "https://github.com"
  
  //MARK: Endpoints
  static let USER_ENDPOINT = "/user"
  static let USERS_ENDPOINT = "/users/"
  static let LOGIN_ENDPOINT = "/login"
  static let OAUTH_ENDPOINT = "/oauth"
  static let AUTHORIZE_ENDPOINT = "/authorize"
  static let REPOSITORIES_ENDPOINT = "/search/repositories"
  static let ACCESS_TOKEN_ENDPOINT = "/access_token"
  
  //MARK: Query keys
  static let ACCESS_TOKEN_KEY = "access_token"
  static let QUERY_KEY = "q"
  static let SORT_KEY = "sort"
  static let ORDER_KEY = "order"
  static let CLIENT_ID_KEY = "client_id"
  static let SCOPE_KEY = "scope"
  static let STATE_KEY = "state"
  
  static let STARS = "stars"
  static let FORKS = "forks"
  static let UPDATED = "updated"
  static let ASCENDING = "desc"
  static let DESCENDING = "asc"
  
  //MARK: Query values
  static let PUBLIC_REPO_SCOPE = "user public_repo"
  static let TEST_STATE = "TEST_STATE"
}

struct OAuth {
  static let clientID: String = "1524b5b7bc93cfe0ce07"
  static let clientSecret: String = "1abac95d0917a5a08f69f7fd260bfd8d1e16a1dd"
  static let SEARCH_LOGGED_USER_URL = "https://api.github.com/user?access_token="
  
  static let CLIENT_ID_KEY = "client_id"
  static let CLIENT_SECRET_KEY = "client_secret"
  static let CODE_KEY = "code"
}
