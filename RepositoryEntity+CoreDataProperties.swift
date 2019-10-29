//
//  RepositoryEntity+CoreDataProperties.swift
//  
//
//  Created by Home on 28/10/2019.
//
//

import Foundation
import CoreData


extension RepositoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RepositoryEntity> {
        return NSFetchRequest<RepositoryEntity>(entityName: "RepositoryEntity")
    }

    @NSManaged public var createdAt: String?
    @NSManaged public var desc: String?
    @NSManaged public var forks: Int32?
    @NSManaged public var forksCount: Int32?
    @NSManaged public var gitUrl: String?
    @NSManaged public var htmlUrl: String?
    @NSManaged public var id: Int32?
    @NSManaged public var isPrivate: Bool?
    @NSManaged public var issuesCount: Int32?
    @NSManaged public var language: String?
    @NSManaged public var name: String?
    @NSManaged public var openIssues: Int32?
    @NSManaged public var pushedAt: String?
    @NSManaged public var size: Int32?
    @NSManaged public var subscribersUrl: String?
    @NSManaged public var updatedAt: String?
    @NSManaged public var watchersCount: Int32?
    @NSManaged public var owner: OwnerEntity?

}
