//
//  User.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation
struct JsonResponse : Codable {
    let incomplete_results : Bool?
    let total_count : Int?
    let repositories : [Repository]?
    
    enum CodingKeys: String, CodingKey {
        
        case incomplete_results = "incomplete_results"
        case total_count = "total_count"
        case repositories = "items"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        incomplete_results = try values.decodeIfPresent(Bool.self, forKey: .incomplete_results)
        total_count = try values.decodeIfPresent(Int.self, forKey: .total_count)
        repositories = try values.decodeIfPresent([Repository].self, forKey: .repositories)
    }
}
