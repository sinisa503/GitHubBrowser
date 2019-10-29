//
//  GitHubBrowserTests.swift
//  GitHubBrowserTests
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import XCTest
import RxSwift
@testable import GitHubBrowser

class GitHubBrowserTests: XCTestCase {
    
    var json:String?
    private let authenticatedUsername = "sinisa503"
    private let randomGithubUsername = "kviksilver"
    private let testSearchTerm = "Swift"
    private let timeoutSeconds = 15.0
    private let disposeBag: DisposeBag = DisposeBag()
    private var testUser: User?
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        testUser = nil
    }
    
    func testGetAuthenticatedUser() {
        let expectation =  XCTestExpectation(description: "LoggedUserInfoExpectation")
        OAuthService.getAuthenticatedUser { (user, error) in
            if error != nil {
                XCTFail()
            } else if let user = user {
                expectation.fulfill()
                XCTAssertEqual(user.login, self.authenticatedUsername)
            } else {
                XCTFail("Authenticated user is nil!")
            }
        }
        wait(for: [expectation], timeout: timeoutSeconds)
    }
    
    func testGetGitHubUserInfo() {
        let expectation =  XCTestExpectation(description: "UserInfoWithTokenExpectation")
        GitHubService.getGitHubUser(username: randomGithubUsername).subscribe(onNext: { user in
            expectation.fulfill()
            XCTAssertEqual(user.login, self.randomGithubUsername)
        }, onError: { error in
            XCTFail()
        }).disposed(by: disposeBag)
        wait(for: [expectation], timeout: timeoutSeconds)
    }
    
    //MARK: Browsing tests
    func testBrowseGitHubWithParametars() {
        
        let allSortOptions:[Sort] = [.forks, .issues, .updated]
        let allOrderOptions:[Order] = [.ascending, .descending]
        
        let allSortOrderOptions:[(sort:Sort, order:Order)] = {
            var arrayOfAllOptions:[(sort:Sort, order:Order)] = []
            for sortOption in allSortOptions {
                for orderOption in allOrderOptions {
                    arrayOfAllOptions.append((sortOption, orderOption))
                }
            }
            return arrayOfAllOptions
        }()
        
        var expectations:[XCTestExpectation] = []
        for (index, sortOrderOption) in allSortOrderOptions.enumerated() {
            let expectation =  XCTestExpectation(description: "BrowseGitWithParametarsExpectationNo:\(index)")
            expectations.append(expectation)
            
            let params = [Api.QUERY_KEY:testSearchTerm, Api.SORT_KEY:sortOrderOption.sort.rawValue, Api.ORDER_KEY:sortOrderOption.order.rawValue]
            
            GitHubService.browseGitHub(searchTerm: testSearchTerm, parametars: params).subscribe(onNext: { repositories in
                XCTAssert(repositories.count > 0)
                for repo in repositories {
                    guard let username = repo.owner?.login else { XCTFail(); return }
                    GitHubService.getGitHubUser(username: username).subscribe(onError: { error in
                        XCTFail("Error: \(error)")
                    }).disposed(by: self.disposeBag)
                }
                expectation.fulfill()
            }, onError: { error in
                XCTFail(error.localizedDescription)
            }).disposed(by: disposeBag)
        }
        
        wait(for: expectations, timeout: timeoutSeconds)
    }
    
    func testStoringUserToCache() {
        
        let expectation =  XCTestExpectation(description: "testStoringUserToCacheExpectation")
        GitHubService.getGitHubUser(username: randomGithubUsername).subscribe(onNext: { user in
            expectation.fulfill()
            
            let testKey = "test_user_key"
            CacheService.cache(user: user, key: testKey)
            let userFromCache = CacheService.getCachedUser(for: testKey)
            
            XCTAssertNotNil(userFromCache, "Not able to get user from cache")
            
            XCTAssertEqual(userFromCache?.name, user.name)
            XCTAssertEqual(userFromCache?.followers, user.followers)
            XCTAssertEqual(userFromCache?.following, user.following)
            XCTAssertEqual(userFromCache?.publicRepos, user.publicRepos)
            XCTAssertEqual(userFromCache?.login, user.login)
            XCTAssertEqual(userFromCache?.avatarUrl, user.avatarUrl)
            XCTAssertEqual(userFromCache?.email, user.email)
            XCTAssertEqual(userFromCache?.bio, user.bio)
            XCTAssertEqual(userFromCache?.htmlUrl, user.htmlUrl)
            XCTAssertEqual(userFromCache?.updatedAt, user.updatedAt)
            XCTAssertEqual(userFromCache?.company, user.company)
            
            
            CacheService.removeFromCache(key: testKey)
            XCTAssertNil(CacheService.getCachedUser(for: testKey))
            
            XCTAssertEqual(user.login, self.randomGithubUsername)
        }, onError: { error in
            XCTFail()
        }).disposed(by: disposeBag)
        wait(for: [expectation], timeout: timeoutSeconds)
    }
}
