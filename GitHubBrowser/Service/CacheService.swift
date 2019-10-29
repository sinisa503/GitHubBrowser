//
//  CacheService.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import AlamofireImage

enum Directory {
   case documents
   case caches
}

class CacheService {
    
    static private let LOGGED_USER_KEY = "logged_user_key"
    private static let cache = Cache<String, User>()
    
    static let imageCache = AutoPurgingImageCache(
        memoryCapacity: UInt64(100).megabytes(),
        preferredMemoryUsageAfterPurge: UInt64(60).megabytes()
    )
    
    static func cache(image: UIImage, for url: String) {
        imageCache.add(image, withIdentifier: url)
    }
    
    static func cachedImage(for url: String) -> UIImage? {
        return imageCache.image(withIdentifier: url)
    }
    
    static func cache(user: User, key: String) {
        cache.insert(user, forKey: key)
    }
    
    static func getCachedUser(for key: String) -> User? {
        return cache.value(forKey: key)
    }
    
    static func removeFromCache(key: String) {
        cache.removeValue(forKey: key)
    }
    
    static var currentUser:User? {
        get { return getCachedUser(for: LOGGED_USER_KEY) }
        set {
            if let user = newValue {
                cache(user: user, key: LOGGED_USER_KEY)
            }
        }
    }
}
