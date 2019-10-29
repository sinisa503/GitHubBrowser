//
//  File.swift
//  GitHubBrowserTests
//
//  Created by Home on 28/10/2019.
//  Copyright © 2019 Sinisa Vukovic. All rights reserved.
//

import Foundation
import CoreData
import XCTest
import RxSwift

@testable import GitHubBrowser

class DatabaseTests: XCTestCase {
    
    var container: NSPersistentContainer?
    private var databaseService: DatabaseService?
    private var testRepository: Repository?
    
    override func setUp() {
        super.setUp()
        
        container = NSPersistentContainer.testContainer()
        databaseService = DatabaseService()
        
        testRepository = {
            if let path = Bundle.main.url(forResource: "responseRepo", withExtension: "json") {
                do {
                    let repositoryData = try Data(contentsOf: path , options: Data.ReadingOptions.mappedIfSafe)
                    let response = try JSONDecoder().decode(JsonResponse.self, from: repositoryData)
                    return response.repositories?.first
                } catch let error {
                    XCTFail(error.localizedDescription)
                }
                
            }
            return nil
        }()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        container = nil
        testRepository = nil
        databaseService = nil
        super.tearDown()
    }
    
    
    func testSavingRepositoryToDatabase() {
        
        guard let context = container?.viewContext, let repository = testRepository, let dbService = databaseService else { XCTFail(); return }
        dbService.save(repository: repository, context: context) { result in
            switch result {
            case .success():
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        dbService.fetchAllStoredRepositories(context: context) { result in
            switch result {
            case .success(let repositories):
                guard let savedRepo = repositories.first else { XCTFail("Repositorie not saved!"); return }
                XCTAssert(repositories.count == 1, "Repository count is more than one")
                XCTAssertEqual(savedRepo.name, testRepository?.name, "Name not equal")
                XCTAssertEqual(savedRepo.desc, testRepository?.description, "Description not equal")
                XCTAssertEqual(savedRepo.language, testRepository?.language, "Language not equal")
                
                XCTAssertNotNil(savedRepo.owner, "Owner is nil!")
                XCTAssertEqual(savedRepo.owner?.login, testRepository?.owner?.login, "Owner name not equal")
                XCTAssertEqual(savedRepo.owner?.htmlUrl, testRepository?.owner?.htmlUrl, "Owner html not equal")
                
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func testFetchRepositoryWithNamePredicate() {
        
        guard let context = container?.viewContext, let repository = testRepository, let repositoryName = repository.name, let dbService = databaseService else { XCTFail(); return }
        dbService.save(repository: repository, context: context) { result in
            switch result {
            case .success():
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        dbService.fetchRepository(with: repositoryName, context: context) { result in
            switch result {
            case .success(let repository):
                guard let repository = repository else { XCTFail("Repository is nil!"); return }
                
                XCTAssertEqual(repository.name, testRepository?.name, "Name not equal")
                XCTAssertEqual(repository.description, testRepository?.description, "Description not equal")
                XCTAssertEqual(repository.language, testRepository?.language, "Language not equal")
                
                XCTAssertNotNil(repository.owner, "Owner is nil!")
                XCTAssertEqual(repository.owner?.login, testRepository?.owner?.login, "Owner name not equal")
                XCTAssertEqual(repository.owner?.htmlUrl, testRepository?.owner?.htmlUrl, "Owner html not equal")
                
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func testDeletingRepositoryFromDatabase() {
        
        guard let context = container?.viewContext, let repository = testRepository, let repositoryName = repository.name, let dbService = databaseService else { XCTFail(); return }
        dbService.save(repository: repository, context: context) { result in
            switch result {
            case .success():
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        dbService.fetchAllStoredRepositories(context: context) { result in
            switch result {
            case .success(let repositories):
                guard let savedRepo = repositories.first else { XCTFail("Repositorie not saved!"); return }
                XCTAssert(repositories.count == 1, "Repository count is more than one")
                XCTAssertEqual(savedRepo.name, testRepository?.name, "Name not equal")
                XCTAssertEqual(savedRepo.desc, testRepository?.description, "Description not equal")
                XCTAssertEqual(savedRepo.language, testRepository?.language, "Language not equal")
                
                XCTAssertNotNil(savedRepo.owner, "Owner is nil!")
                XCTAssertEqual(savedRepo.owner?.login, testRepository?.owner?.login, "Owner name not equal")
                XCTAssertEqual(savedRepo.owner?.htmlUrl, testRepository?.owner?.htmlUrl, "Owner html not equal")
                
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        dbService.deleteRepository(with: repositoryName, context: context) { result in
            switch result {
            case .success():
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        dbService.fetchAllStoredRepositories(context: context) { result in
            switch result {
            case .success(let repositories):
                XCTAssert(repositories.count == 0, "Repository not deleted")
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }
}

extension NSPersistentContainer {
    
    class func testContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "GitHubBrowser")
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        persistentStoreDescription.shouldAddStoreAsynchronously = false // Make it simpler in test env
        
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("\(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }
}

