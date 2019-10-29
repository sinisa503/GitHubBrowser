//
//  User.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation
struct Repository : Codable {
    
    let subscribersUrl : String?
    let openIssues : Int?
    let size : Int?
    let gitUrl : String?
    let id : Int?
    let htmlUrl : String?
    let description : String?
    let forksCount : Int?
    let name : String?
    let owner : Owner?
    let watchersCount : Int?
    let createdAt : String?
    let updatedAt : String?
    let language : String?
    let pushedAt : String?
    let forks : Int?
    let issuesCount: Int?
    let isPrivate:Bool?
    
    init(entity: RepositoryEntity) {
        self.subscribersUrl = entity.subscribersUrl
        self.openIssues = Int(entity.openIssues)
        self.size = Int(entity.size)
        self.gitUrl = entity.gitUrl
        self.id = Int(entity.id)
        self.htmlUrl = entity.htmlUrl
        self.description = entity.desc
        self.forksCount = Int(entity.forksCount)
        self.name = entity.name
        self.watchersCount = Int(entity.watchersCount)
        self.createdAt = entity.createdAt
        self.updatedAt = entity.updatedAt
        self.language = entity.language
        self.pushedAt = entity.pushedAt
        self.forks = Int(entity.forks)
        self.issuesCount = Int(entity.issuesCount)
        self.isPrivate = entity.isPrivate
        if let owner = entity.owner {
            self.owner = Owner(entity: owner)
        } else {
            self.owner = nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        
        case subscribersUrl = "subscribers_url"
        case openIssues = "open_issues"
        case size = "size"
        case gitUrl = "git_url"
        case id = "id"
        case htmlUrl = "html_url"
        case description = "description"
        case forks = "forks"
        case createdAt = "created_at"
        case forksCount = "forks_count"
        case language = "language"
        case pushedAt = "pushed_at"
        case owner = "owner"
        case name = "name"
        case updatedAt = "updated_at"
        case watchersCount = "watchers_count"
        case issuesCount = "open_issues_count"
        case isPrivate = "private"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        subscribersUrl = try values.decodeIfPresent(String.self, forKey: .subscribersUrl)
        openIssues = try values.decodeIfPresent(Int.self, forKey: .openIssues)
        size = try values.decodeIfPresent(Int.self, forKey: .size)
        gitUrl = try values.decodeIfPresent(String.self, forKey: .gitUrl)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        htmlUrl = try values.decodeIfPresent(String.self, forKey: .htmlUrl)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        forks = try values.decodeIfPresent(Int.self, forKey: .forks)
        forksCount = try values.decodeIfPresent(Int.self, forKey: .forksCount)
        language = try values.decodeIfPresent(String.self, forKey: .language)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        pushedAt = try values.decodeIfPresent(String.self, forKey: .pushedAt)
        owner = try values.decodeIfPresent(Owner.self, forKey: .owner)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        watchersCount = try values.decodeIfPresent(Int.self, forKey: .watchersCount)
        issuesCount = try values.decodeIfPresent(Int.self, forKey: .issuesCount)
        isPrivate = try values.decodeIfPresent(Bool.self, forKey: .isPrivate)
    }
}
