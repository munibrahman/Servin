//
//  S3Manager.swift
//  ServinV2
//
//  Created by Munib Rahman on 2019-04-27.
//  Copyright © 2019 Voltic Labs Inc. All rights reserved.
//

import Foundation
import UIKit
import AWSS3
import ImageSlideshow

class S3Manager: NSObject {
    
    
    
    public class func `default` () -> S3Manager {
        return S3Manager()
    }
    
    
    public func downloadImage(bucket: String?,
                              key: String?,
                              expression: AWSS3TransferUtilityDownloadExpression?,
                              onSuccess: @escaping (UIImage) -> (),
                              onError: @escaping (Error?) -> ()) {
        
        
        var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
        completionHandler = { (task, URL, data, error) -> Void in
            DispatchQueue.main.async(execute: {
                
                if let error = error {
                    onError(error)
                }
                
                if let data = data, let image = UIImage.init(data: data) {
                    onSuccess(image)
                } else {
                    onError(nil)
                }
                
                // Do something e.g. Alert a user for transfer completion.
                // On failed downloads, `error` contains the error object.
            })
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        
        
        if let bucket = bucket, let key = key {
            
            transferUtility.downloadData(
                fromBucket: bucket,
                key: key,
                expression: expression,
                completionHandler: completionHandler
                ).continueWith {
                    (task) -> AnyObject? in if let error = task.error {
                        print("Error: \(error.localizedDescription)")
                        onError(error)
                    }
                    
                    if let _ = task.result {
                        // Do something with downloadTask.
                        
                    }
                    return nil;
            }
            
        } else if let key = key {
            
            
            transferUtility.downloadData(forKey: key, expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
                if let error = task.error {
                    print("Error: \(error.localizedDescription)")
                    onError(error)
                }
                
                if let _ = task.result {
                    // Do something with downloadTask.
                    
                }
                return nil;
            }
        }
        
        
        
        
    }
    
    
    
}

class S3Source: NSObject, InputSource {

    /// url to load
    public var key: String
    
    /// placeholder used before image is loaded
    public var placeholder: UIImage?
    
    /// Initializes a new source with a URL
    /// - parameter url: a url to load
    /// - parameter placeholder: a placeholder used before image is loaded
    public init(key: String, placeholder: UIImage? = nil) {
        self.key = key
        self.placeholder = placeholder
        super.init()
    }
    
    public func load(to imageView: UIImageView, with callback: @escaping (UIImage?) -> Void) {
        imageView.loadImageUsingS3Key(key: key)
        callback(imageView.image)
        
//        imageView.af_setImage(withURL: self.url, placeholderImage: placeholder, filter: nil, progress: nil) { (response) in
//            callback(response.result.value)
//        }
    }
    
    public func cancelLoad(on imageView: UIImageView) {
        imageView.af_cancelImageRequest()
    }
}


