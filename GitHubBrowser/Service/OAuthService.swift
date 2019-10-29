//
//  OAuthService.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit
import Alamofire
import Keychain

class OAuthService {
    
    static var OAuthToken:String? {
        get {
            if let accessKey = Keychain.load(Api.ACCESS_TOKEN_KEY) {
                return accessKey
            }else {
                return nil
            }
        }
        set {
            if let accessKey = newValue {
                _ = Keychain.save(accessKey, forKey: Api.ACCESS_TOKEN_KEY)
                getAuthenticatedUser { (user, error) in
                    CacheService.currentUser = user
                }
            }
        }
    }
    
    
    static func getAuthenticatedUser(completion:@escaping UserCompletion) {
        guard let accessToken = OAuthToken else {
            startOAuth2Login()
            return
        }
        
        let parameters: Parameters = [Api.ACCESS_TOKEN_KEY:accessToken]
        
        NetworkingService.performRequest(resource: User.self, endpoint: Api.USER_ENDPOINT, parameters: parameters) { result in
            switch result {
            case .success(let user):
                completion(user,nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    static func startOAuth2Login() {
        var components = URLComponents(string: Api.GITHUB_URL)
        components?.path.append(contentsOf: Api.LOGIN_ENDPOINT)
        components?.path.append(contentsOf: Api.OAUTH_ENDPOINT)
        components?.path.append(contentsOf: Api.AUTHORIZE_ENDPOINT)
        
        let clientIdQuery = URLQueryItem(name: Api.CLIENT_ID_KEY, value: OAuth.clientID)
        let scopeQuery = URLQueryItem(name: Api.SCOPE_KEY, value: Api.PUBLIC_REPO_SCOPE)
        let stateQuery = URLQueryItem(name: Api.STATE_KEY, value: Api.TEST_STATE)
        
        components?.queryItems = [clientIdQuery, scopeQuery, stateQuery]
        
        guard let authURL:URL = components?.url else { return }
        UIApplication.shared.open(authURL, options: [:], completionHandler: nil)
    }
    
    
    static func authenticateClient(code:String) {
        let params = [OAuth.CLIENT_ID_KEY: OAuth.clientID,OAuth.CLIENT_SECRET_KEY: OAuth.clientSecret, OAuth.CODE_KEY: code]
        
        //"https://github.com/login/oauth/access_token"
        var components = URLComponents(string: Api.GITHUB_URL)
        components?.path.append(contentsOf: Api.LOGIN_ENDPOINT)
        components?.path.append(contentsOf: Api.OAUTH_ENDPOINT)
        components?.path.append(contentsOf: Api.ACCESS_TOKEN_ENDPOINT)
        
        guard let url = components?.url else { return }
        
        Alamofire.request(url, method: .post, parameters: params).responseString { responseString in
            if let response = responseString.result.value {
                self.extractAndSaveAuthCode(response: response)
            }
        }
    }
    
    static func processOAuthResponse(url: URL) -> String? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var code:String?
        if let queryItems = components?.queryItems {
            for queryItem in queryItems {
                if (queryItem.name.lowercased() == OAuth.CODE_KEY) {
                    code = queryItem.value
                }
            }
        }
        return code
    }
    
    private static func extractAndSaveAuthCode(response:String) {
        let array = response.split { $0 == Constant.EQUALS }
        let str = String(array[1])
        if let index = str.index(of: Constant.AMPERSAND) {
            let accessToken = String(str.prefix(upTo: index))
            OAuthToken = accessToken
        }
    }
}
