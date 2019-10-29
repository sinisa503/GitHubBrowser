//
//  User.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation
struct Owner : Codable {

  let login : String?
  let id : Int?
  let url : String?
  let avatarUrl:String?
  let followersUrl : String?
  let followingUrl : String?
  let htmlUrl : String?
  let reposUrl : String?
   

	enum CodingKeys: String, CodingKey {
    case login = "login"
    case id = "id"
    case url = "url"
    case avatarUrl = "avatar_url"
    case htmlUrl = "html_url"
    case followingUrl = "following_url"
    case followersUrl = "followers_url"
    case reposUrl = "repos_url"
	}

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    login = try values.decodeIfPresent(String.self, forKey: .login)
    id = try values.decodeIfPresent(Int.self, forKey: .id)
    url = try values.decodeIfPresent(String.self, forKey: .url)
    avatarUrl = try values.decode(String.self, forKey: .avatarUrl)
    followingUrl = try values.decode(String.self, forKey: .followingUrl)
    followersUrl = try values.decode(String.self, forKey: .followersUrl)
    htmlUrl = try values.decode(String.self, forKey: .htmlUrl)
    reposUrl = try values.decode(String.self, forKey: .reposUrl)
  }
    
    init(entity: OwnerEntity) {
        self.login = entity.login
        self.id = Int(entity.id)
        self.url = entity.url
        self.avatarUrl = entity.avatarUrl
        self.followersUrl = entity.followersUrl
        self.followingUrl = entity.followingUrl
        self.htmlUrl = entity.htmlUrl
        self.reposUrl = entity.reposUrl
    }
}
