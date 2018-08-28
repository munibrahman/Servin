//
//  LoginViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-02.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import Macaw
import AWSCognitoIdentityProvider
import Alamofire
import JWTDecode
import SwiftyJSON

class WelcomeViewController: UIViewController {
    
    
    @IBOutlet var logoView: SVGView!
    
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var loginLabel: UILabel!
    
    
    var response: AWSCognitoIdentityUserGetDetailsResponse?
    var user: AWSCognitoIdentityUser?
    
    @IBOutlet var termsOfServiceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupViews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var userAttributes: [AWSCognitoIdentityProviderAttributeType]?
        var user = AppDelegate.defaultUserPool().currentUser()
        
        let pool = AppDelegate.defaultUserPool()
        if (user == nil) {
            user = pool.currentUser()
        }
        
        print(user)
        if (user?.isSignedIn)! {
            print("Current User is signed in")
             print(user?.username)
            
            // On the first time, just refresh all tokens in the keychain.
            KeyChainStore.shared.refreshTokens()
            
            let navVC = UINavigationController.init(rootViewController: SelectCategoriesViewController())
            self.present(navVC, animated: true, completion: nil)
        } else {
            // Do nothing...
            print("Current User is not logged in...")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        signUpButton.layer.cornerRadius = signUpButton.frame.height / 2.0
        signUpButton.layer.borderColor = UIColor.white.cgColor
        signUpButton.layer.borderWidth = 2.0
        signUpButton.clipsToBounds = true
        
        setupNotificationLabel()
    }
    
    func setupViews() {
        
        loginLabel.isUserInteractionEnabled = true
        
        let loginTap = UITapGestureRecognizer.init(target: self, action: #selector(showLogin))
        
        loginLabel.addGestureRecognizer(loginTap)
    }
    
    @objc func showLogin () {
        
        print("Show login")
        
        self.user = AppDelegate.defaultUserPool().getUser()
        self.refresh()
    }
    
    func refresh() {
        self.user?.getDetails().continueOnSuccessWith { (task) -> AnyObject? in
            DispatchQueue.main.async(execute: {
                self.response = task.result
            })
            return nil
        }
    }
    
    func setupNotificationLabel () {
        
        termsOfServiceLabel.text = "By tapping Create an account or Log in, I agree to Servin’s Terms of Service, Payments Terms of Service and Privacy Policy."
        
        let text = (termsOfServiceLabel.text)!
        let underlineAttriString = NSMutableAttributedString(string: text)
        
        let tosRange = (text as NSString).range(of: "Terms of Service")
        underlineAttriString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: tosRange)
        
        let ptsRange = (text as NSString).range(of: "Payments Terms of Service")
        underlineAttriString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: ptsRange)
        
        let ppRange = (text as NSString).range(of: "Privacy Policy")
        underlineAttriString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: ppRange)
        
        termsOfServiceLabel.attributedText = underlineAttriString
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signUpAction(_ sender: UIButton) {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let navController = UINavigationController.init(rootViewController: sb.instantiateViewController(withIdentifier: "SignUp1ViewController"))
        
        self.present(navController, animated: true, completion: nil)
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let text = (termsOfServiceLabel.text)!
        
        let tosRange = (text as NSString).range(of: "Terms of Service")
        let ptsRange = (text as NSString).range(of: "Payments Terms of Service")
        let ppRange = (text as NSString).range(of: "Privacy Policy")
        
        if gesture.didTapAttributedTextInLabel(label: termsOfServiceLabel, inRange: tosRange) {
            print("Tapped tos")
            
        } else if gesture.didTapAttributedTextInLabel(label: termsOfServiceLabel, inRange: ptsRange) {
            print("Tapped pts")
            
        } else if gesture.didTapAttributedTextInLabel(label: termsOfServiceLabel, inRange: ppRange) {
            print("Tapped pp")
            
        } else {
            print("Tapped none")
        }
    }

}

