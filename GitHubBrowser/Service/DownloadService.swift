//
//  DownloadService.swift
//  GitHubBrowser
//
//  Created by Sinisa Vukovic on 28/10/2019.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit
import Alamofire

enum DownloadOption {
    case failure(Error?)
    case success(UIImage)
}

class DownloadService {
    
    //Check if image exists in cache first and if not then dowmload it and put it to cache
    static func getImage(from url:String, completion:@escaping (DownloadOption)->()) {
        if let image = CacheService.cachedImage(for: url) {
            completion(.success(image))
        }else {
            downloadImage(from: url) { option in            
                switch option {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let image):
                    CacheService.cache(image: image, for: url)
                    completion(.success(image))
                }
            }
        }
    }
    
    private static func downloadImage(from url:String, completion:@escaping (DownloadOption)->()){
        Alamofire.request(url, method: .get).responseImage {response in
            guard let image = response.result.value else {
                if let error = response.error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(image))
        }
    }
}
