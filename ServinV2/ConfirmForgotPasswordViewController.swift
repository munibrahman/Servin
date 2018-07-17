//
//  ConfirmForgotPasswordViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-07-09.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider
import Macaw

class ConfirmForgotPasswordViewController: UIViewController, UITextFieldDelegate {

    // TODO: Spread out the verification code, password and confirm password into 3 different views.
    
    var user: AWSCognitoIdentityUser?
    
    @IBOutlet weak var confirmationCode: UITextField!
    @IBOutlet weak var proposedPassword: UITextField!
    @IBOutlet var confirmProposedPassword: UITextField!
    @IBOutlet var nextButtonSVGView: GoForwardMacawView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupNextButton()
        setupTextField()
    }
    
    func setupNextButton() {
        
        let nextScreenGesture = UITapGestureRecognizer.init(target: self, action: #selector(goForward))
        
        nextButtonSVGView.addGestureRecognizer(nextScreenGesture)
    }
    
    @objc func goForward() {
        guard let confirmationCodeValue = self.confirmationCode.text, !confirmationCodeValue.isEmpty else {
            let alertController = UIAlertController(title: "Password Field Empty",
                                                    message: "Please enter a password of your choice.",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion:  nil)
            return
        }
        
        if confirmProposedPassword.text != proposedPassword.text {
            let alertController = UIAlertController(title: "Password don't match",
                                                    message: "Please make sure that you entered the same password.",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion:  nil)
        }
        
        //confirm forgot password with input from ui.
        self.user?.confirmForgotPassword(confirmationCodeValue, password: self.proposedPassword.text!).continueWith {[weak self] (task: AWSTask) -> AnyObject? in
            guard let strongSelf = self else { return nil }
            DispatchQueue.main.async(execute: {
                if let error = task.error as NSError? {
                    let alertController = UIAlertController(title: "Cannot Reset Password",
                                                            message: error.userInfo["message"] as? String,
                                                            preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    
                    self?.present(alertController, animated: true, completion:  nil)
                } else {
                    
                    let presentingController = strongSelf.presentingViewController
                    strongSelf.presentingViewController?.dismiss(animated: true, completion: {
                        let alert = UIAlertController(title: "Password Reset", message: "Password reset.  Please log into the account with your email and new password.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        presentingController?.present(alert, animated: true, completion: nil)
                        
                    }
                    )
                }
            })
            return nil
        }
    }
    
    func setupTextField() {
        confirmationCode.backgroundColor = UIColor.clear
        confirmationCode.textColor = UIColor.white
        confirmationCode.borderStyle = .none
        confirmationCode.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
        confirmationCode.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        confirmationCode.keyboardAppearance = .dark
        confirmationCode.keyboardType = .default
        confirmationCode.delegate = self
        
        proposedPassword.backgroundColor = UIColor.clear
        proposedPassword.textColor = UIColor.white
        proposedPassword.borderStyle = .none
        proposedPassword.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
        proposedPassword.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        proposedPassword.keyboardAppearance = .dark
        proposedPassword.keyboardType = .default
        proposedPassword.isSecureTextEntry = true
        proposedPassword.delegate = self
        
        confirmProposedPassword.backgroundColor = UIColor.clear
        confirmProposedPassword.textColor = UIColor.white
        confirmProposedPassword.borderStyle = .none
        confirmProposedPassword.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
        confirmProposedPassword.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        confirmProposedPassword.keyboardAppearance = .dark
        confirmProposedPassword.keyboardType = .default
        confirmProposedPassword.isSecureTextEntry = true
        confirmProposedPassword.delegate = self
        
        
    }
    
    func setupNavigationBar() {
        let barButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_white"), style: .plain, target: self, action: #selector(barButtonPressed))
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    
    @objc func barButtonPressed() {
        _ = self.navigationController?.popViewController(animated: true)
    }

}
