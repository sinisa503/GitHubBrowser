//
//  CoreDataService.swift
//  GitHubBrowser
//
//  Created by Home on 28/10/2019.
//  Copyright © 2019 Sinisa Vukovic. All rights reserved.
//

import Foundation
import CoreData

class DatabaseService {
    
    
    func save(repository: Repository, context: NSManagedObjectContext, completion: (Result<Void, Error>)->()) {
        
            if let repoEntity = NSEntityDescription.entity(forEntityName: "RepositoryEntity", in: context) {
                
                let newRepo = RepositoryEntity(entity: repoEntity, insertInto: context)
                
                newRepo.createdAt = repository.createdAt
                newRepo.desc = repository.description
                if let forks = repository.forks {
                    newRepo.forks = Int32(forks)
                }
                if let forksCount = repository.forksCount {
                    newRepo.forksCount = Int32(forksCount)
                }
                newRepo.gitUrl = repository.gitUrl
                newRepo.htmlUrl = repository.htmlUrl
                if let id = repository.id {
                    newRepo.id = Int32(id)
                }
                if let isPrivate = repository.isPrivate {
                    newRepo.isPrivate = isPrivate
                }
                if let issuesCount = repository.issuesCount {
                    newRepo.issuesCount = Int32(issuesCount)
                }
                newRepo.language = repository.language
                newRepo.name = repository.name
                if let openIssues = repository.openIssues {
                    newRepo.openIssues = Int32(openIssues)
                }
                if let size = repository.size {
                    newRepo.size = Int32(size)
                }
                newRepo.subscribersUrl = repository.subscribersUrl
                newRepo.updatedAt = repository.updatedAt
                if let watchersCount = repository.watchersCount {
                    newRepo.watchersCount = Int32(watchersCount)
                }
                
                if let owner = repository.owner {
                    newRepo.owner = save(owner: owner, for: newRepo, context: context)
                }
                
                do {
                    try context.save()
                    completion(.success(()))
                } catch let error {
                    completion(.failure(error))
                }

        }
    }
    
    private func save(owner: Owner, for repository: RepositoryEntity, context: NSManagedObjectContext) -> OwnerEntity? {
        
            if let ownerEntity = NSEntityDescription.entity(forEntityName: "OwnerEntity", in: context) {
                let newOwner = OwnerEntity(entity: ownerEntity, insertInto: context)
                
                newOwner.avatarUrl = owner.avatarUrl
                newOwner.followersUrl = owner.followersUrl
                newOwner.followingUrl = owner.followingUrl
                newOwner.htmlUrl = owner.htmlUrl
                if let id = owner.id {
                    newOwner.id = Int32(id)
                }
                newOwner.login = owner.login
                newOwner.reposUrl = owner.reposUrl
                newOwner.url = owner.url
                newOwner.repository = repository
                
                return newOwner
        }
        return nil
    }
    
    func fetchAllStoredRepositories(context: NSManagedObjectContext, completion: (Result<[RepositoryEntity], Error>)->()) {
        let fetchRequest:NSFetchRequest<RepositoryEntity> = RepositoryEntity.fetchRequest()
        do {
            let repositories = try context.fetch(fetchRequest)
            completion(.success(repositories))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func fetchRepository(with name: String, context: NSManagedObjectContext, completion: (Result<Repository?, Error>)->()) {
        let fetchRequest:NSFetchRequest<RepositoryEntity> = RepositoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        
        do {
            if let repository = try context.fetch(fetchRequest).first {
                completion(.success(Repository(entity: repository)))
            } else {
                completion(.success(nil))
            }
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func deleteRepository(with name: String, context: NSManagedObjectContext, completion: (Result<Void, Error>)->()) {
        let fetchRequest:NSFetchRequest<RepositoryEntity> = RepositoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        
        do {
            if let repository = try context.fetch(fetchRequest).first {
                context.delete(repository)
                completion(.success(()))
            }
        } catch let error {
            completion(.failure(error))
        }
    }
}
