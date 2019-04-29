//
//  BackendServer.swift
//  ServinV2
//
//  Created by Developer on 2018-08-27.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage
import AWSMobileClient
import AWSS3


class BackendServer: NSObject {
    
    enum CognitoKeys: String {
        case sub = "sub"
        case emailVerified = "email_"
    }
    
    static var shared = BackendServer()
    
    
    let baseUrl = "https://9z2epuh1wa.execute-api.us-east-1.amazonaws.com"
    
    // This function downloads the image and saves it at a location on the phone.
    
//    func downloadProfileImage() {
//        let expression = AWSS3TransferUtilityDownloadExpression()
//        expression.progressBlock = {(task, progress) in DispatchQueue.main.async(execute: {
//            // Do something e.g. Update a progress bar.
//        })
//        }
//        
//        var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
//        completionHandler = { (task, URL, data, error) -> Void in
//            DispatchQueue.main.async(execute: {
//                if let error = error {
//                    print("Failed to download profile Image")
//                    print(error)
//                }
//                
//                if let data = data, let image = UIImage.init(data: data) {
//                    print("Downloaded Image")
//                    DefaultsWrapper.set(image: image, named: Key.imagePath)
//                }
//                // Do something e.g. Alert a user for transfer completion.
//                // On failed downloads, `error` contains the error object.
//            })
//        }
//        
//        let transferUtility = AWSS3TransferUtility.default()
//        
//        transferUtility.downloadData(forKey: S3ProfileImageKeyName,
//                                     expression: expression,
//                                     completionHandler: completionHandler)
//            .continueWith { (task) -> Any? in
//                if let error = task.error {
//                    print("Error Downloading profile image")
//                    print(error)
//                }
//                
//                if let _ = task.result {
//                    
//                }
//                
//                return nil
//                
//        }
//        
//    }
    
    
//    func fetchProfileImage() -> UIImage? {
//
//        if let img = DefaultsWrapper.getImage(named: Key.imagePath) {
//            print("Image exists, fetch it")
//            return img
//        } else {
//            self.downloadProfileImage()
//        }
//
//        return nil
//    }
    
    func fetchAttributes() {
        
//        APIManager.sharedInstance.getUser(username: AWSMobileClient.sharedInstance().username ?? "NO TOKEN", onSuccess: { (json) in
//            print(json)
//            if let about = json["about"].string {
//                DefaultsWrapper.setString(key: Key.aboutMe, value: about)
//            }
//
//        }) { (err) in
//            print(err)
//        }
       
        AWSMobileClient.sharedInstance().getUserAttributes { (response, error) in
            if error != nil {
                print("Error: \(error)")
                print("Can't retrieve attributes for this user")
                return
            }
            
            if let res = response {
                
                for attr in res {
                    switch attr.key {
                    case Key.sub.rawValue:
                        DefaultsWrapper.setString(key: Key.sub, value: attr.value)
                    case Key.givenName.rawValue:
                        DefaultsWrapper.setString(key: Key.givenName, value: attr.value)
                    case Key.familyName.rawValue:
                        DefaultsWrapper.setString(key: Key.familyName, value: attr.value)
                    case Key.emailVerified.rawValue:
                        DefaultsWrapper.setBool(key: Key.emailVerified, value: Bool(attr.value ?? "0")!)
                    case Key.email.rawValue:
                        DefaultsWrapper.setString(key: Key.email, value: attr.value)
                    default:
                        print("Unable to find a specific key, make one.")
                        print(attr.key)
                        print(attr.value)
                    }
                }
                
            }
            
            
        }
        
//        if let user = AppDelegate.defaultUserPool().currentUser() {
//
//            user.getDetails().continueOnSuccessWith { (response) -> Any? in
//
//                if let result = response.result {
//                    if let attributes = result.userAttributes {
//
//                        for attr in attributes {
//
//                            if let attrName = attr.name {
//
//                                switch attrName {
//                                case Key.sub.rawValue:
//                                    DefaultsWrapper.setString(key: Key.sub, value: attr.value)
//                                case Key.givenName.rawValue:
//                                    DefaultsWrapper.setString(key: Key.givenName, value: attr.value)
//                                case Key.familyName.rawValue:
//                                    DefaultsWrapper.setString(key: Key.familyName, value: attr.value)
//                                case Key.emailVerified.rawValue:
//                                    DefaultsWrapper.setBool(key: Key.emailVerified, value: Bool(attr.value ?? "0")!)
//                                case Key.email.rawValue:
//                                    DefaultsWrapper.setString(key: Key.email, value: attr.value)
//                                default:
//                                    print("Unable to find a specific key, make one.")
//                                    print(attrName)
//                                    print(attr.value)
//                                }
//
//                            }
//
//                        }
//                    }
//                }
//
//                return nil
//            }
//        }
        
    }
    
    
}
