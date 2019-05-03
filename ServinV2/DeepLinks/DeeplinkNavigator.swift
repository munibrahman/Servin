//
//  DeeplinkNavigator.swift
//  Deeplinks
//
//  Created by Stanislav Ostrovskiy on 5/25/17.
//  Copyright © 2017 Stanislav Ostrovskiy. All rights reserved.
//

import Foundation
import UIKit
import AWSMobileClient

class DeeplinkNavigator {
    
    static let shared = DeeplinkNavigator()
    private init() { }
    
    var alertController = UIAlertController()
    
    func proceedToDeeplink(_ type: DeeplinkType) {
        switch type {
        case .messages(.root):
            showMessages()
        case .messages(.details(id: let id)):
            displayAlert(title: "Messages Details \(id)")
        case .dropNewPin:
            displayAlert(title: "Drop a new pin")
        case .myPins:
            displayAlert(title: "My Pins")
        case .savedPins:
            displayAlert(title: "Saved pins")
        case .verification:
            displayAlert(title: "Check verification")
        
        case .confirm(let username, let code):
            print("confirm called in here")
            confirmSignUp(email: username, code: code)
        case .forgot(let username, let code):
            print("Forgot password called in here")
            forgotPassword(username: username, code: code)
        }
    }
    
    private func displayAlert(title: String) {
        alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okButton)
        alertController.title = title
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    private func showMessages() {
        let navController = UINavigationController.init(rootViewController: MessageViewController())
        
        UIApplication.topViewController()?.present(navController, animated: true, completion: nil)
    }
    
    private func confirmSignUp(email: String, code: String) {
        AWSMobileClient.sharedInstance().confirmSignUp(username: email, confirmationCode: code) { (signUpResult, error) in
            if let signUpResult = signUpResult {
                switch(signUpResult.signUpConfirmationState) {
                case .confirmed:
                    print("User is signed up and confirmed.")
                    print(AWSMobileClient.sharedInstance().username)
                    
                    if let savedEmail = KeyChainStore.shared.fetchSignUpEmail(), let savedPass = KeyChainStore.shared.fetchSignUpPassword() {
                        if savedEmail == email {
                            print("User that signed up also confirmed their email")
                            AWSMobileClient.sharedInstance().signIn(username: savedEmail, password: savedPass, completionHandler: { (result, error) in
                                if let error = error {
                                    // SHow error
                                    print(error)
                                }
                                
                                if let result = result {
                                    KeyChainStore.shared.refreshTokens()
                                    print("Successfully signed user in")
                                    print(result)
                                    // Show the initial controller to sign the person in.
                                    DispatchQueue.main.async {
                                        UIApplication.topViewController()?.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                                    }
                                }
                            })
                        }
                    } else {
                        // Show that email is confirmed and they can login now.
                    }
                    
                case .unconfirmed:
                    print("User is not confirmed and needs verification via \(signUpResult.codeDeliveryDetails!.deliveryMedium) sent at \(signUpResult.codeDeliveryDetails!.destination!)")
                case .unknown:
                    print("Unexpected case")
                }
            } else if let error = error {
                print("Error confirming user")
                print(error)
                print("\(error.localizedDescription)")
            }
        }
    }

    private func forgotPassword(username: String, code: String) {
        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String.init(describing: ConfirmForgotPasswordViewController.self)) as? ConfirmForgotPasswordViewController {
            vc.username = username
            vc.code = code
            
            let navVC = UINavigationController.init(rootViewController: vc)
            
            UIApplication.topViewController()?.present(navVC, animated: true, completion: nil)
        }
        
    }
}
