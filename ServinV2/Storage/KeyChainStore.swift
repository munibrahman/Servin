//
//  KeyChainStore.swift
//  ServinV2
//
//  Created by Developer on 2018-08-27.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import Foundation
import JWTDecode
import AWSMobileClient

class KeyChainStore: NSObject {

    
    enum Keys: String {
        case refreshToken = "refresh_token"
        case accessToken = "access_token"
        case idToken = "id_token"
        case latestSignUpEmail = "latest_signup_email"
        case latestSignUpPass = "latest_signup_password"
    }
    
    static let shared = KeyChainStore()
    
    let keychain = AWSUICKeyChainStore.init()
    
    func refreshTokens() {
        
        print("Refreshing tokens off the bat")
        AWSMobileClient.sharedInstance().getTokens { (tokens, error) in
            if let error = error {
                print("Error getting token \(error.localizedDescription)")
            } else if let tokens = tokens {
                print(tokens.accessToken!.tokenString!)
                
                print("ID Token \(tokens.idToken?.tokenString)")
                print("Access Token \(tokens.accessToken?.tokenString)")
                print("Refresh Token \(tokens.refreshToken?.tokenString)")
                
                if let idToken = tokens.idToken {
                    
                    if (!self.keychain.setString(idToken.tokenString, forKey: KeyChainStore.Keys.idToken.rawValue)) {
                        print("unable to store id token")
                    }
                    
                    let jwt = try? decode(jwt: idToken.tokenString!)
                    
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
                
                if let accessToken = tokens.accessToken {
                    if (!self.keychain.setString(accessToken.tokenString, forKey: KeyChainStore.Keys.accessToken.rawValue)) {
                        print("unable to store access token")
                    }
                }
                
                if let refreshToken = tokens.refreshToken {
                    if (!self.keychain.setString(refreshToken.tokenString, forKey: KeyChainStore.Keys.refreshToken.rawValue)) {
                        print("unable to store refresh token")
                    }
                }
                
                
            }
            
            
            
        }
        
    }
    
    func storeSignUp(email: String) -> Bool {
        return self.keychain.setString(email, forKey: KeyChainStore.Keys.latestSignUpEmail.rawValue)
    }
    
    func storeSignUp(password: String) -> Bool {
        return self.keychain.setString(password, forKey: KeyChainStore.Keys.latestSignUpPass.rawValue)
    }
    
    func fetchSignUpEmail() -> String? {
        return keychain.string(forKey: KeyChainStore.Keys.latestSignUpEmail.rawValue)
    }
    
    func fetchSignUpPassword() -> String? {
        return keychain.string(forKey: KeyChainStore.Keys.latestSignUpPass.rawValue)
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































