//
//  DownloadImage.swift
//  CareemTest
//
//  Created by Arun Kumar Nama on 30/4/18.
//  Copyright © 2018 Arun Kumar Nama. All rights reserved.
//

import UIKit

class ImageDownload: NSObject {
 
    let imageCache = NSCache<NSString, UIImage>();
    
    func downloadImage(url: String, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void) {
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            completion(cachedImage, nil)
        } else {
            let apiClient = NetworkDispatcher (name: "downloadImage", host: Constants.Api.imageHost);
            let req = UserRequests.imageDownload(poster_path: url)
            apiClient.execute(request: req) { (result) in
                switch result {
                case .success(let data):
                    if let data = data, let image = UIImage(data: data) {
                        self.imageCache.setObject(image, forKey: url as NSString)
                        completion(image, nil)
                    } else {
                        completion(nil, nil)
                    }
                case .failure(let error):
                    completion(nil, error);
                }
            }
        }
    }
}
