//
//  SoftwareMFAViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-07-12.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

class SoftwareMFAViewController: UIViewController, AWSCognitoIdentitySoftwareMfaSetupRequired {
    
    
    @IBOutlet var nextButtonSVGView: GoForwardMacawView!
    @IBOutlet var codeTextField: UITextField!
    
    var softwareMfaSetupRequiredCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentitySoftwareMfaSetupRequiredDetails>?
    
    func getSoftwareMfaSetupDetails(_ softwareMfaSetupInput: AWSCognitoIdentitySoftwareMfaSetupRequiredInput, softwareMfaSetupRequiredCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentitySoftwareMfaSetupRequiredDetails>) {
        print("getSoftwareMfaSetupDetails")
        
        self.softwareMfaSetupRequiredCompletionSource = softwareMfaSetupRequiredCompletionSource
        
        
        
    }
    
    func didCompleteMfaSetupStepWithError(_ error: Error?) {
        DispatchQueue.main.async {
            if let error = error as NSError? {
                let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                        message: error.userInfo["message"] as? String,
                                                        preferredStyle: .alert)
                let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
                alertController.addAction(retryAction)
                
                self.present(alertController, animated: true, completion:  nil)
            } else {
                // Dismiss the software MFA screen.
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButtonSVGView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(goForward)))
        // Do any additional setup after loading the view.
        
        setupTextField()
        
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        let barButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "x_white"), style: .plain, target: self, action: #selector(barButtonPressed))
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    
    @objc func barButtonPressed() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func goForward() {
        
        if codeTextField.text != nil {
            let details = AWSCognitoIdentitySoftwareMfaSetupRequiredDetails.init(userCode: codeTextField.text!, friendlyDeviceName: UIDevice.current.name)
            self.softwareMfaSetupRequiredCompletionSource?.set(result: details)
        }
    }
    
    func setupTextField() {
        codeTextField.backgroundColor = UIColor.clear
        codeTextField.textColor = UIColor.white
        codeTextField.borderStyle = .none
        codeTextField.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
        codeTextField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        codeTextField.keyboardType = .numberPad
        codeTextField.keyboardAppearance = .dark
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
