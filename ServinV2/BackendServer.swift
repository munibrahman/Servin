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
    
    static var shared = BackendServer()
    
    let baseUrl = "https://9z2epuh1wa.execute-api.us-east-1.amazonaws.com"
    
    func fetchProfileImage() -> UIImage? {
        
        var image: UIImage?
        
        if let img = DefaultsWrapper.getImage(named: Key.imagePath) {
            return img
        } else {
            // Image doesn't exist download from server
            
            
            if let idToken = KeyChainStore.shared.fetchIdToken() {
                
                let headers: HTTPHeaders = [
                    "Authorization": idToken
                ]

                
                Alamofire.request("\(self.baseUrl)/dev/user/picture", method: HTTPMethod.get, headers: headers).responseImage(completionHandler: { (response) in
                    if let img = response.result.value {
                        image = img
                        _ = DefaultsWrapper.set(image: img, named: Key.imagePath)
                    } else {
                        print(response)
                        
                    }
                })
            }

        }
        
        return image
    }
    
    
}
