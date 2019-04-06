//
//  SignUp3ViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-03.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import Macaw
import AWSMobileClient
import NotificationBannerSwift

class SignUp3ViewController: UIViewController {

    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var nextButtonSVGView: GoForwardMacawView!
    
    var sentTo: String?
    
    
    // These values are given to us by the previous VC
    var firstName: String?
    var lastName: String?
    var emailAddress: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupBackground()
        setupNavigationBar()
        setupTextField()
        
        
        nextButtonSVGView.isUserInteractionEnabled = true
        
        let nextScreenGesture = UITapGestureRecognizer.init(target: self, action: #selector(goForward))
        
        nextButtonSVGView.addGestureRecognizer(nextScreenGesture)
    }
    
    @objc func goForward () {
        
        
        
        
        if passwordTextField.text?.isEmpty ?? true {
            let alertController = UIAlertController.init(title: nil, message: "Are you sure that's correct?", preferredStyle: .alert)
            
            let okAction = UIAlertAction.init(title: "Let me double check", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            // Do the confirmations here...
            
            
            
            guard let userNameValue = self.emailAddress, !userNameValue.isEmpty,
                let passwordValue = self.passwordTextField.text, !passwordValue.isEmpty else {
                    let alertController = UIAlertController(title: "Missing Required Fields",
                                                            message: "Username / Password are required for registration.",
                                                            preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion:  nil)
                    return
            }
            
            var attributes = [String: String]()


            if let emailValue = self.emailAddress, !emailValue.isEmpty {

                attributes["email"] = emailValue
            }

            if let lastName = self.lastName {
                attributes["family_name"] = lastName
            }

            if let firstName = self.firstName {
                attributes["given_name"] = firstName
            }
            
            nextButtonSVGView.toggleProgress(showProgress: true)
            nextButtonSVGView.isUserInteractionEnabled = false
            
            AWSMobileClient.sharedInstance().signUp(username: userNameValue,
                                                    password: passwordValue,
                                                    userAttributes: attributes) { (signUpResult, error) in
                                                        if let signUpResult = signUpResult {
                                                            switch(signUpResult.signUpConfirmationState) {
                                                            case .confirmed:
                                                                print("User is signed up and confirmed.")
                                                                // If a user has signed up and is already confirmed, no need to show the confirmation screen. Just log them in and show the Main VC.
                                                                self.signUserIn()
                                                            case .unconfirmed:
                                                                print("User is not confirmed and needs verification via \(signUpResult.codeDeliveryDetails!.deliveryMedium) sent at \(signUpResult.codeDeliveryDetails!.destination!)")
                                                                
                                                                DispatchQueue.main.async {
                                                                    if let signUpConfirmationViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmSignUpViewController") as? ConfirmSignUpViewController {
                                                                        
                                                                        signUpConfirmationViewController.username = userNameValue
                                                                        self.navigationController?.pushViewController(signUpConfirmationViewController, animated: true)
                                                                    }
                                                                }
                                                            case .unknown:
                                                                print("Unexpected case")
                                                                DispatchQueue.main.async {
                                                                    self.showWarningNotification(title: "Error", subtitle: "Unable sign up at this time, please try again or contact us.")
                                                                    self.nextButtonSVGView.toggleProgress(showProgress: false)
                                                                    self.nextButtonSVGView.isUserInteractionEnabled = true
                                                                }
                                                            }
                                                        } else if let error = error {
                                                            if let error = error as? AWSMobileClientError {
                                                                switch(error) {
                                                                case .usernameExists(let message):
                                                                    print(message)

                                                                    DispatchQueue.main.async {
                                                                        self.showErrorNotification(title: "Error", subtitle: message)
                                                                        self.nextButtonSVGView.toggleProgress(showProgress: false)
                                                                        self.nextButtonSVGView.isUserInteractionEnabled = true
                                                                    }
                                                                default:
                                                                    DispatchQueue.main.async {
                                                                        self.showWarningNotification(title: "Error", subtitle: "Unable sign up at this time, please try again or contact us.")
                                                                        self.nextButtonSVGView.toggleProgress(showProgress: false)
                                                                        self.nextButtonSVGView.isUserInteractionEnabled = true
                                                                    }
                                                                    break
                                                                }
                                                            } else {
                                                            print("\(error.localizedDescription)")
                                                                self.showWarningNotification(title: "Error", subtitle: "Unable sign up at this time, please try again or contact us.")
                                                            }
                                                        }
            }
        }
        
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setProgress(3/5, animated: true)
        
        // This allows the keyboard to popup automatically
        passwordTextField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupBackground() {
        self.view.backgroundColor = UIColor.greyBackgroundColor
    }
    
    func setupNavigationBar() {
        let barButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_white"), style: .plain, target: self, action: #selector(barButtonPressed))
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    
    @objc func barButtonPressed() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    func signUserIn() {
        
        guard let email = self.emailAddress else {
            self.showErrorNotification(title: "Error", subtitle: "Is your email address correct?")
            return
        }
        
        guard let password = self.passwordTextField.text, !password.isEmpty else {
            self.showErrorNotification(title: "Error", subtitle: "Is your password correct?")
            return
        }
        
        AWSMobileClient.sharedInstance().signIn(username: email, password: self.passwordTextField.text!) { (result, error) in
            
            DispatchQueue.main.async {
                self.nextButtonSVGView.toggleProgress(showProgress: false)
                self.nextButtonSVGView.isUserInteractionEnabled = true
            }
            
            if let error = error {
                self.showErrorNotification(title: "Error", subtitle: "\(error)")
                print("Error: \(error.localizedDescription)")
            } else if let result = result {
                switch (result.signInState) {
                case .signedIn:
                    print("User is signed in.")
                    DispatchQueue.main.async {
                        self.nextButtonSVGView.toggleProgress(showProgress: false)
                        self.nextButtonSVGView.isUserInteractionEnabled = true
                        let mainVC = Constants.getMainContentVC()
                        self.present(mainVC, animated: true, completion: nil)
                    }
                default:
                    self.showErrorNotification(title: "Error", subtitle: "Unable to sign in, please try again.")
                    print("\(result.signInState.rawValue)")
                }
            } else {
                self.showErrorNotification(title: "Error", subtitle: "Unable to talk to the server, please try again")
            }
            
        }
    }
    
    func setupTextField() {
        
        passwordTextField.delegate = self
        
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.textColor = UIColor.white
        passwordTextField.borderStyle = .none
        passwordTextField.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTextField.isSecureTextEntry = true
        passwordTextField.keyboardAppearance = .dark
    }


}

extension SignUp3ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            goForward()
            return false
        }
        
        return true
    }
}
