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
        
        if let idToken = KeyChainStore.shared.fetchIdToken() {
            
            print("id token is here")
            let headers: HTTPHeaders = [
                "Authorization": idToken
            ]
            
            
            Alamofire.request("\(self.baseUrl)/dev/user/picture", method: HTTPMethod.get, headers: headers).responseImage(completionHandler: { (response) in
                
                print("got response")
                if let img = response.result.value {
                    print(response)
                    _ = DefaultsWrapper.set(image: img, named: Key.imagePath)
                    
                } else {
                    print(response)
                    
                }
                
            })
        } else {
            
            print("No keychain...")
            //KeyChainStore.shared.refreshTokens()
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
                                case Key.school.rawValue:
                                    DefaultsWrapper.setString(key: Key.school, value: attr.value)
                                case Key.emailVerified.rawValue:
                                    DefaultsWrapper.setBool(key: Key.emailVerified, value: Bool(attr.value ?? "0")!)
                                case Key.aboutMe.rawValue:
                                    DefaultsWrapper.setString(key: Key.aboutMe, value: attr.value)
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
