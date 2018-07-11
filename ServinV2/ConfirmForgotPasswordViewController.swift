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

class ConfirmForgotPasswordViewController: UIViewController {

    
    var user: AWSCognitoIdentityUser?
    
    @IBOutlet weak var confirmationCode: UITextField!
    @IBOutlet weak var proposedPassword: UITextField!
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
        
        //confirm forgot password with input from ui.
        self.user?.confirmForgotPassword(confirmationCodeValue, password: self.proposedPassword.text!).continueWith {[weak self] (task: AWSTask) -> AnyObject? in
            guard let strongSelf = self else { return nil }
            DispatchQueue.main.async(execute: {
                if let error = task.error as NSError? {
                    let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                            message: error.userInfo["message"] as? String,
                                                            preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    
                    self?.present(alertController, animated: true, completion:  nil)
                } else {
                    let _ = strongSelf.navigationController?.popToRootViewController(animated: true)
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
        
        proposedPassword.backgroundColor = UIColor.clear
        proposedPassword.textColor = UIColor.white
        proposedPassword.borderStyle = .none
        proposedPassword.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
        proposedPassword.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        proposedPassword.keyboardAppearance = .dark
        proposedPassword.keyboardType = .default
        proposedPassword.isSecureTextEntry = true
        
        
    }
    
    func setupNavigationBar() {
        let barButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_white"), style: .plain, target: self, action: #selector(barButtonPressed))
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    
    @objc func barButtonPressed() {
        _ = self.navigationController?.popViewController(animated: true)
    }

}
