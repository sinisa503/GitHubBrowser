//
//  User.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation
struct User : Codable {
    
    let publicRepos : Int?
    let followers : Int?
    let following : Int?
    let name : String?
    let login : String?
    let avatarUrl : String?
    let email : String?
    let bio : String?
    let htmlUrl : String?
    let updatedAt : String?
    let company : String?
    
    
    enum CodingKeys: String, CodingKey {
        
        case publicRepos = "public_repos"
        case email = "email"
        case bio = "bio"
        case followers = "followers"
        case following = "following"
        case login = "login"
        case name = "name"
        case updatedAt = "updated_at"
        case company = "company"
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        publicRepos = try values.decodeIfPresent(Int.self, forKey: .publicRepos)
        bio = try values.decodeIfPresent(String.self, forKey: .bio)
        followers = try values.decodeIfPresent(Int.self, forKey: .followers)
        following = try values.decodeIfPresent(Int.self, forKey: .following)
        company = try values.decodeIfPresent(String.self, forKey: .company)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        login = try values.decodeIfPresent(String.self, forKey: .login)
        avatarUrl = try values.decodeIfPresent(String.self, forKey: .avatarUrl)
        htmlUrl = try values.decodeIfPresent(String.self, forKey: .htmlUrl)
    }
    
}
