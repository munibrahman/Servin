//
//  SignUp1ViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-03.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import KYNavigationProgress
import Macaw

class SignUp1ViewController: UIViewController {

    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    
    @IBOutlet var nextButtonSVGView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
        setupBackground()
        setupNavigationBar()
        setupTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set progress with animation.
        self.navigationController?.progressTintColor = UIColor.navigationProgressColor
        self.navigationController?.setProgress(1/5, animated: true)
        self.navigationController?.progressHeight = 3.0
        
        // This allows the keyboard to popup automatically
        firstNameTextField.becomeFirstResponder()
        
        let nextScreenGesture = UITapGestureRecognizer.init(target: self, action: #selector(goForward))
        
        nextButtonSVGView.addGestureRecognizer(nextScreenGesture)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
    }

    @objc func goForward () {
        let mainSB = UIStoryboard.init(name: "Main", bundle: nil)
        
        if firstNameTextField.text?.isEmpty ?? true  || lastNameTextField.text?.isEmpty ?? true {
            let alertController = UIAlertController.init(title: nil, message: "Please make sure that all the fields are complete", preferredStyle: .alert)
            
            let okAction = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            if let secondSignUpVC = mainSB.instantiateViewController(withIdentifier: "SignUp2ViewController") as? SignUp2ViewController {
                
                secondSignUpVC.firstName = firstNameTextField.text
                secondSignUpVC.lastName = lastNameTextField.text
                self.navigationController?.pushViewController(secondSignUpVC, animated: true)
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func setupTextFields() {
        firstNameTextField.backgroundColor = UIColor.clear
        firstNameTextField.textColor = UIColor.white
        firstNameTextField.borderStyle = .none
        firstNameTextField.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        firstNameTextField.keyboardAppearance = .dark
        firstNameTextField.keyboardType = .default
        firstNameTextField.autocapitalizationType = .words
        
        lastNameTextField.backgroundColor = UIColor.clear
        lastNameTextField.textColor = UIColor.white
        lastNameTextField.borderStyle = .none
        lastNameTextField.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        lastNameTextField.keyboardAppearance = .dark
        lastNameTextField.keyboardType = .default
        lastNameTextField.autocapitalizationType = .words
        
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
    }
    
    @objc func barButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    


}

extension SignUp1ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
            return false
        } else if textField == lastNameTextField {
            goForward()
            return false
        }
        
        return true
    }
}
