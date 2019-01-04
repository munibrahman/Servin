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


class BackendServer: NSObject {
    
    enum CognitoKeys: String {
        case sub = "sub"
        case emailVerified = "email_"
    }
    
    static var shared = BackendServer()
    
    
    let baseUrl = "https://9z2epuh1wa.execute-api.us-east-1.amazonaws.com"
    
    // This function downloads the image and saves it at a location on the phone.
    
    func downloadProfileImage() {
        
        
        // Image doesn't exist download from server
        print("Image doesn't exist, need to download from server")
        
        // TODO Handle nil cases
        APIManager.sharedInstance.getUser(username: (AppDelegate.defaultUserPool().currentUser()?.username!)!, onSuccess: { (json) in
            print(json)
            if let url = json["imageURL"].string {
                Alamofire.request(url).responseImage { response in
                    if let image = response.result.value {
                        debugPrint(response)
                        
                        print(response.request)
                        print(response.response)
                        debugPrint(response.result)
                        _ = DefaultsWrapper.set(image: image, named: Key.imagePath)
                    }
                }
            }
        }) { (err) in
            print(err)
        }
        

        
    }
    
    
    func fetchProfileImage() -> UIImage? {
        
        if let img = DefaultsWrapper.getImage(named: Key.imagePath) {
            print("Image exists, fetch it")
            return img
        } else {
            self.downloadProfileImage()
        }
        
        return nil
    }
    
    func fetchAttributes() {
        
        APIManager.sharedInstance.getUser(username: (AppDelegate.defaultUserPool().currentUser()?.username)!, onSuccess: { (json) in
            print(json)
            if let about = json["about"].string {
                DefaultsWrapper.setString(key: Key.aboutMe, value: about)
            }
            
        }) { (err) in
            print(err)
        }
       
        if let user = AppDelegate.defaultUserPool().currentUser() {
            
            user.getDetails().continueOnSuccessWith { (response) -> Any? in
                
                if let result = response.result {
                    if let attributes = result.userAttributes {
                        
                        for attr in attributes {
                            
                            if let attrName = attr.name {
                                
                                switch attrName {
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
                                    print(attrName)
                                    print(attr.value)
                                }
                                
                            }
                            
                        }
                    }
                }
                
                return nil
            }
        }
        
    }
    
    
}
