//
//  LoginViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-02.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import Macaw

class WelcomeViewController: UIViewController {
    
    
    @IBOutlet var logoView: SVGView!
    
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var loginLabel: UILabel!
    
    
    @IBOutlet var termsOfServiceLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupViews()
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
//        signInButton.layer.cornerRadius = signInButton.frame.height / 2
//        signInButton.layer.borderWidth = 1.0
//        signInButton.clipsToBounds = true
//
//        emailTextField.backgroundColor = UIColor.clear
//        emailTextField.textColor = UIColor.white
//        emailTextField.borderStyle = .none
//        emailTextField.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
//        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
//        emailTextField.keyboardAppearance = .dark
//        emailTextField.keyboardType = .emailAddress
//
//
//        passwordTextField.backgroundColor = UIColor.clear
//        passwordTextField.textColor = UIColor.white
//        passwordTextField.borderStyle = .none
//        passwordTextField.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
//        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
//        passwordTextField.isSecureTextEntry = true
//        passwordTextField.keyboardAppearance = .dark
        
        loginLabel.isUserInteractionEnabled = true
        
        let loginTap = UITapGestureRecognizer.init(target: self, action: #selector(showLogin))
        
        loginLabel.addGestureRecognizer(loginTap)
    }
    
    @objc func showLogin () {
        
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

