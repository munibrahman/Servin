//
//  KeyChainStore.swift
//  ServinV2
//
//  Created by Developer on 2018-08-27.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider
import JWTDecode

class KeyChainStore: NSObject {

    
    enum Keys: String {
        case refreshToken = "refresh_token"
        case accessToken = "access_token"
        case idToken = "id_token"
    }
    
    static let shared = KeyChainStore()
    
    let keychain = AWSUICKeyChainStore.init()
    
    func refreshTokens() {
        
        if let user = AppDelegate.defaultUserPool().currentUser() {
            
            if (user.isSignedIn) {
                
                user.getSession().continueOnSuccessWith(block: { (session) -> Any? in
                    print("ID Token \(session.result?.idToken?.tokenString)")
                    print("Access Token \(session.result?.accessToken?.tokenString)")
                    print("Refresh Token \(session.result?.refreshToken?.tokenString)")

                    if let idToken = session.result?.idToken {
                        
                        if (!self.keychain.setString(idToken.tokenString, forKey: KeyChainStore.Keys.idToken.rawValue)) {
                            print("unable to store id token")
                        }
                        
                        let jwt = try? decode(jwt: idToken.tokenString)
                        
                        // Saving NSUserDefaults here too
                        if let jwtokenized = jwt {
                            print(jwtokenized.body)
                            
                            if let givenName = jwtokenized.body[Key.givenName.rawValue] as? String {
                                print("saved given name")
                                DefaultsWrapper.setString(key: Key.givenName, value: givenName)
                            }
                            
                            if let familyName = jwtokenized.body[Key.familyName.rawValue] as? String {
                                print("saved family name")
                                DefaultsWrapper.setString(key: Key.familyName, value: familyName)
                            }
                            
                            if let userName = jwtokenized.body["cognito:username"] as? String {
                                print("saved user name")
                                DefaultsWrapper.setString(key: Key.userName, value: userName)
                                
                            }
                            
                        }
                        
                    }
                    
                    if let accessToken = session.result?.accessToken {
                        if (!self.keychain.setString(accessToken.tokenString, forKey: KeyChainStore.Keys.accessToken.rawValue)) {
                            print("unable to store access token")
                        }
                    }
                    
                    if let refreshToken = session.result?.refreshToken {
                        if (!self.keychain.setString(refreshToken.tokenString, forKey: KeyChainStore.Keys.refreshToken.rawValue)) {
                            print("unable to store refresh token")
                        }
                    }
                    
        
                    return nil
                })
                
                
            }
        }
        
        
    }
    
    func fetchRefreshToken() -> String? {
        return keychain.string(forKey: KeyChainStore.Keys.refreshToken.rawValue)
    }
    
    func fetchIdToken() -> String? {
        return keychain.string(forKey: KeyChainStore.Keys.idToken.rawValue)
    }
    
    func fetchAccessToken() -> String? {
        return keychain.string(forKey: KeyChainStore.Keys.accessToken.rawValue)
    }
    
    func removeAllKeys() {
        keychain.removeAllItems()
    }

}































