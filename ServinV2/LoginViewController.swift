//
//  LoginViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-02.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var signInButton: UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupViews()
    }

    func setupViews() {
        signInButton.layer.cornerRadius = signInButton.frame.height / 2
        signInButton.layer.borderWidth = 1.0
        signInButton.clipsToBounds = true
     
        emailTextField.backgroundColor = UIColor.clear
        emailTextField.textColor = UIColor.white
        emailTextField.borderStyle = .none
        emailTextField.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        emailTextField.keyboardAppearance = .dark
        emailTextField.keyboardType = .emailAddress
        
        
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.textColor = UIColor.white
        passwordTextField.borderStyle = .none
        passwordTextField.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        passwordTextField.isSecureTextEntry = true
        passwordTextField.keyboardAppearance = .dark
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
