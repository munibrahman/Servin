//
//  ConfirmForgotPasswordViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-07-09.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import Macaw
import AWSMobileClient
import NotificationBannerSwift

class ConfirmForgotPasswordViewController: UIViewController, UITextFieldDelegate {

    // TODO: Spread out the verification code, password and confirm password into 3 different views.
    
    @IBOutlet weak var verificationSentLabel: UILabel!
    @IBOutlet weak var confirmationCode: UITextField!
    @IBOutlet weak var proposedPassword: UITextField!
    @IBOutlet var confirmProposedPassword: UITextField!
    @IBOutlet var nextButtonSVGView: GoForwardMacawView!
    
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupNextButton()
        setupTextField()
        
        verificationSentLabel.text = "We sent a verification code to: \(username ?? "your email.") Please enter it below."
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
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion:  nil)
            return
        }
        
        if confirmProposedPassword.text != proposedPassword.text {
            let alertController = UIAlertController(title: "Password incorrect",
                                                    message: "Please make sure that you entered the same password.",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion:  nil)
        }
        
        nextButtonSVGView.toggleProgress(showProgress: true)
        nextButtonSVGView.isUserInteractionEnabled = false
        
        AWSMobileClient.sharedInstance().confirmForgotPassword(username: username!, newPassword: confirmProposedPassword.text!, confirmationCode: confirmationCodeValue) { (forgotPasswordResult, error) in
            
            DispatchQueue.main.async {
                self.nextButtonSVGView.toggleProgress(showProgress: false)
                self.nextButtonSVGView.isUserInteractionEnabled = true
            }
            
            if let forgotPasswordResult = forgotPasswordResult {
                switch(forgotPasswordResult.forgotPasswordState) {
                case .done:
                    print("Password changed successfully")
                    DispatchQueue.main.async {
                        let banner = NotificationBanner.init(title: "Success!", subtitle: "Password changed successfully!", leftView: nil, rightView: nil, style: BannerStyle.success, colors: nil)
                        banner.show()
                    }
                    
                // TODO: Show the main screen here.
                    print("Is user signed in")
                    print(AWSMobileClient.sharedInstance().isSignedIn)
                    self.signInUser()
                default:
                    print("Error: Could not change password.")
                }
            } else if let error = error {
                print("Error occurred: \(error)")
                DispatchQueue.main.async {
                    let banner = NotificationBanner.init(title: "Error", subtitle: "\(error)", leftView: nil, rightView: nil, style: BannerStyle.warning, colors: nil)
                    banner.show()
                }
            }
        }
        
    }
    
    // After a password has been reset, we will simply try to sign the user in, makes it easier in terms of UX.
    func signInUser() {
        AWSMobileClient.sharedInstance().signIn(username: username!,
                                                password: confirmProposedPassword.text!) { (signInResult, error) in
                                                    if let error = error  {
                                                        print("\(error.localizedDescription)")
                                                    } else if let signInResult = signInResult {
                                                        switch (signInResult.signInState) {
                                                        case .signedIn:
                                                            print("User is signed in.")
                                                            
                                                            DispatchQueue.main.async {
                                                                self.nextButtonSVGView.toggleProgress(showProgress: false)
                                                                self.nextButtonSVGView.isUserInteractionEnabled = true
                                                                let mainVC = Constants.getMainContentVC()
                                                                self.present(mainVC, animated: true, completion: nil)
                                                            }
                                                            
                                                        case .smsMFA:
                                                            DispatchQueue.main.async {
                                                                self.nextButtonSVGView.toggleProgress(showProgress: false)
                                                                self.nextButtonSVGView.isUserInteractionEnabled = true
                                                                
                                                                if let mfaVC = UIViewController.init(nibName: String.init(describing: MFAViewController.self), bundle: nil) as? MFAViewController {
                                                                    mfaVC.destination = signInResult.codeDetails!.destination!
                                                                    self.navigationController?.pushViewController(mfaVC, animated: true)
                                                                } else {
                                                                    self.showErrorNotification(title: "Hmmm", subtitle: "Something doesn't seem right here, can you please try again?")
                                                                }
                                                                
                                                            }
                                                            
                                                            print("SMS message sent to \(signInResult.codeDetails!.destination!)")
                                                        default:
                                                            DispatchQueue.main.async {
                                                                self.nextButtonSVGView.toggleProgress(showProgress: false)
                                                                self.nextButtonSVGView.isUserInteractionEnabled = true
                                                                self.showErrorNotification(title: "Error", subtitle: "Unable to reset your password, please try again.")
                                                            }
                                                            print("Sign In needs info which is not yet supported.")
                                                        }
                                                    }
        }
    }
    
    func setupTextField() {
        confirmationCode.backgroundColor = UIColor.clear
        confirmationCode.textColor = UIColor.white
        confirmationCode.borderStyle = .none
        confirmationCode.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
        confirmationCode.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        confirmationCode.keyboardAppearance = .dark
        confirmationCode.keyboardType = .default
        confirmationCode.delegate = self
        
        proposedPassword.backgroundColor = UIColor.clear
        proposedPassword.textColor = UIColor.white
        proposedPassword.borderStyle = .none
        proposedPassword.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
        proposedPassword.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        proposedPassword.keyboardAppearance = .dark
        proposedPassword.keyboardType = .default
        proposedPassword.isSecureTextEntry = true
        proposedPassword.delegate = self
        
        confirmProposedPassword.backgroundColor = UIColor.clear
        confirmProposedPassword.textColor = UIColor.white
        confirmProposedPassword.borderStyle = .none
        confirmProposedPassword.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
        confirmProposedPassword.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == confirmationCode {
            proposedPassword.becomeFirstResponder()
            return false
        } else if textField == proposedPassword {
            confirmProposedPassword.becomeFirstResponder()
            return false
        } else if textField == confirmProposedPassword {
            goForward()
            return false
        }
        
        return true
    }
}
