//
//  SignUp3ViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-03.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import Macaw

import AWSCognitoIdentityProvider

class SignUp3ViewController: UIViewController {

    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var nextButtonSVGView: GoForwardMacawView!
    
    var pool: AWSCognitoIdentityUserPool?
    var sentTo: String?
    
    
    // These values are given to us by the previous VC
    var firstName: String?
    var lastName: String?
    var emailAddress: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pool = AppDelegate.defaultUserPool()

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
            
            var attributes = [AWSCognitoIdentityUserAttributeType]()
            
            
            if let emailValue = self.emailAddress, !emailValue.isEmpty {
                let email = AWSCognitoIdentityUserAttributeType()
                email?.name = "email"
                email?.value = emailValue
                attributes.append(email!)
            }
            
            if let lastName = self.lastName {
                let family_name = AWSCognitoIdentityUserAttributeType.init(name: "family_name", value: lastName)
                attributes.append(family_name)
            }
            
            if let firstName = self.firstName {
                let given_name = AWSCognitoIdentityUserAttributeType.init(name: "given_name", value: firstName)
                attributes.append(given_name)
            }
            
            nextButtonSVGView.toggleProgress(showProgress: true)
            nextButtonSVGView.isUserInteractionEnabled = false
            
            //sign up the user
            self.pool?.signUp(userNameValue, password: passwordValue, userAttributes: attributes, validationData: nil).continueWith {[weak self] (task) -> Any? in
                guard let strongSelf = self else { return nil }
                DispatchQueue.main.async(execute: {
                    
                    strongSelf.nextButtonSVGView.toggleProgress(showProgress: false)
                    strongSelf.nextButtonSVGView.isUserInteractionEnabled = true
                    
                    if let error = task.error as NSError? {
                        let alertController = UIAlertController(title: "Error",
                                                                message: error.userInfo["message"] as? String,
                                                                preferredStyle: .alert)
                        let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
                        alertController.addAction(retryAction)
                        
                        self?.present(alertController, animated: true, completion:  nil)
                    } else if let result = task.result  {
                        // handle the case where user has to confirm his identity via email / SMS
                        if (result.user.confirmedStatus != AWSCognitoIdentityUserStatus.confirmed) {
                            strongSelf.sentTo = result.codeDeliveryDetails?.destination
                            
                            if let signUpConfirmationViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmSignUpViewController") as? ConfirmSignUpViewController {
                                
                                signUpConfirmationViewController.sentTo = strongSelf.sentTo
                                signUpConfirmationViewController.user = strongSelf.pool?.getUser(strongSelf.emailAddress!)
                                
                                strongSelf.navigationController?.pushViewController(signUpConfirmationViewController, animated: true)
                            }
                            
                        } else {
                            
                            // If no confirmation required then just show the app.
                            strongSelf.navigationController?.finishProgress()
//                            let constant = Constants()
                            strongSelf.present(Constants.getMainContentVC(), animated: true, completion: nil)
                        }
                    }
                    
                })
                return nil
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
    
    func setupTextField() {
        
        passwordTextField.delegate = self
        
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.textColor = UIColor.white
        passwordTextField.borderStyle = .none
        passwordTextField.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        passwordTextField.isSecureTextEntry = true
        passwordTextField.keyboardAppearance = .dark
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

extension SignUp3ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            goForward()
            return false
        }
        
        return true
    }
}
