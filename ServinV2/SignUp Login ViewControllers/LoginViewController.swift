//
//  LoginViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-18.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import Pulley
import AWSMobileClient
import NotificationBannerSwift

class LoginViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var nextButtonSVGView: GoForwardMacawView!
    @IBOutlet var forgotPasswordLabel: UILabel!
    
    var emailText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupBackground()
        setupNavigationBar()
        // Do any additional setup after loading the view.
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.passwordTextField.text = nil
        self.emailTextField.text = emailText
        
        emailTextField.becomeFirstResponder()
        
        self.passwordTextField?.addTarget(self, action: #selector(inputDidChange(_:)), for: .editingChanged)
        self.emailTextField?.addTarget(self, action: #selector(inputDidChange(_:)), for: .editingChanged)
    }
    
    @objc func inputDidChange(_ sender:AnyObject) {
        if (self.passwordTextField?.text != nil && self.emailTextField?.text != nil) {
            self.nextButtonSVGView.isHidden = false
        } else {
            self.nextButtonSVGView?.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {

        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.backgroundColor = UIColor.clear
        emailTextField.textColor = UIColor.white
        emailTextField.borderStyle = .none
        emailTextField.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        emailTextField.keyboardAppearance = .dark
        emailTextField.keyboardType = .emailAddress

        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.textColor = UIColor.white
        passwordTextField.borderStyle = .none
        passwordTextField.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTextField.isSecureTextEntry = true
        passwordTextField.keyboardAppearance = .dark
        
        forgotPasswordLabel.isUserInteractionEnabled = true
        forgotPasswordLabel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(forgotPasswordTapped)))
        
        nextButtonSVGView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(goForward)))
    }
    
    @objc func forgotPasswordTapped() {
        
        self.navigationController?.pushViewController(UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResetPasswordViewController"), animated: true)
    }
    
    func setupBackground() {
        self.view.backgroundColor = UIColor.greyBackgroundColor
    }
    
    func setupNavigationBar() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        let barButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "x_white"), style: .plain, target: self, action: #selector(barButtonPressed))
        navigationItem.leftBarButtonItem = barButtonItem
        
        
    }
    
    @objc func barButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func goForward() {
        
        print("forward pressed")
        self.nextButtonSVGView.toggleProgress(showProgress: true)
        self.nextButtonSVGView.isUserInteractionEnabled = false
        
        
        
        guard let username = emailTextField.text, !username.isEmpty else {
            self.nextButtonSVGView.toggleProgress(showProgress: false)
            self.nextButtonSVGView.isUserInteractionEnabled = true
            // Show error about username
            return
        }

        guard let password = passwordTextField.text, !password.isEmpty else {
            self.nextButtonSVGView.toggleProgress(showProgress: false)
            self.nextButtonSVGView.isUserInteractionEnabled = true
            // Show error about password
            return
        }

        AWSMobileClient.sharedInstance().signIn(username: username,
                                                password: password) { (signInResult, error) in
            if let error = error  {
                print("\(error.localizedDescription)")
                
                DispatchQueue.main.async {
                    self.nextButtonSVGView.toggleProgress(showProgress: false)
                    self.nextButtonSVGView.isUserInteractionEnabled = true
                    
                    let banner = NotificationBanner.init(title: "Error", subtitle: "\(error)", leftView: nil, rightView: nil, style: BannerStyle.danger, colors: nil)
                    banner.show()
                    
                }
                
            } else if let signInResult = signInResult {
                switch (signInResult.signInState) {
                case .signedIn:
                    print("User is signed in.")
                    
                    self.hasUserCheckedCategories()
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
                        
                        let banner = NotificationBanner.init(title: "Error", subtitle: "Sign In needs info which is not yet supported.", leftView: nil, rightView: nil, style: BannerStyle.danger, colors: nil)
                        banner.show()
                        
                    }
                    print("Sign In needs info which is not yet supported.")
                }
            }
        }
    }
    
    func hasUserCheckedCategories()  {
        
    }


}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
            return false
        } else if textField == passwordTextField {
            goForward()
            return false
        }
        
        return true
    }
}
