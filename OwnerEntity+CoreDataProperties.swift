//
//  OwnerEntity+CoreDataProperties.swift
//  
//
//  Created by Home on 28/10/2019.
//
//

import Foundation
import CoreData


extension OwnerEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<OwnerEntity> {
        return NSFetchRequest<OwnerEntity>(entityName: "OwnerEntity")
    }
    
    @NSManaged public var avatarUrl: String?
    @NSManaged public var followersUrl: String?
    @NSManaged public var followingUrl: String?
    @NSManaged public var htmlUrl: String?
    @NSManaged public var id: Int32
    @NSManaged public var login: String?
    @NSManaged public var reposUrl: String?
    @NSManaged public var url: String?
    @NSManaged public var repository: RepositoryEntity?
    
}
