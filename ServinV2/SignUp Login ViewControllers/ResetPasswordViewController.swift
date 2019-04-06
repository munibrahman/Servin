//
//  ResetPasswordViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-19.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import Macaw
import AWSMobileClient
import NotificationBannerSwift


// TODO: User awsmobileclient
class ResetPasswordViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var nextButtonSVGView: GoForwardMacawView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTextField()
        setupNextButton()
        

        self.view.backgroundColor = UIColor.greyBackgroundColor
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        emailTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func goForward () {
        guard let username = self.emailTextField.text, !username.isEmpty else {
            
            let alertController = UIAlertController(title: "Missing email",
                                                    message: "Please enter a valid email.",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion:  nil)
            return
        }
        
        nextButtonSVGView.toggleProgress(showProgress: true)
        nextButtonSVGView.isUserInteractionEnabled = false
        
        AWSMobileClient.sharedInstance().forgotPassword(username: username) { (forgotPasswordResult, error) in
            if let forgotPasswordResult = forgotPasswordResult {
                switch(forgotPasswordResult.forgotPasswordState) {
                case .confirmationCodeSent:
                    
                    print("Confirmation code sent via \(forgotPasswordResult.codeDeliveryDetails!.deliveryMedium) to: \(forgotPasswordResult.codeDeliveryDetails!.destination!)")
                    
                    DispatchQueue.main.async {
                        self.nextButtonSVGView.toggleProgress(showProgress: false)
                        self.nextButtonSVGView.isUserInteractionEnabled = true
                        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmForgotPasswordViewController") as? ConfirmForgotPasswordViewController {
                            vc.username = username
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    
                default:
                    print("Error: Invalid case.")
                    
                }
            } else if let error = error {
                print("Error occurred: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    let banner = NotificationBanner.init(title: "Error", subtitle: "\(error.localizedDescription)", leftView: nil, rightView: nil, style: BannerStyle.warning, colors: nil)
                    banner.show()
                    self.nextButtonSVGView.toggleProgress(showProgress: false)
                    self.nextButtonSVGView.isUserInteractionEnabled = true
                }
            }
        }
        
    }
    
    func setupNextButton() {

        let nextScreenGesture = UITapGestureRecognizer.init(target: self, action: #selector(goForward))
        
        nextButtonSVGView.addGestureRecognizer(nextScreenGesture)
    }
    
    func setupTextField() {
        emailTextField.delegate = self
        emailTextField.backgroundColor = UIColor.clear
        emailTextField.textColor = UIColor.white
        emailTextField.borderStyle = .none
        emailTextField.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        emailTextField.keyboardAppearance = .dark
        emailTextField.keyboardType = .emailAddress
        
    }
    
    func setupNavigationBar() {
        let barButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_white"), style: .plain, target: self, action: #selector(barButtonPressed))
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    
    @objc func barButtonPressed() {
        _ = self.navigationController?.popViewController(animated: true)
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

extension ResetPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            goForward()
            return false
        }
        
        return true
    }
}
