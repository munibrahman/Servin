//
// Copyright 2014-2018 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Amazon Software License (the "License").
// You may not use this file except in compliance with the
// License. A copy of the License is located at
//
//     http://aws.amazon.com/asl/
//
// or in the "license" file accompanying this file. This file is
// distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, express or implied. See the License
// for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import AWSCognitoIdentityProvider
import Macaw

class ConfirmSignUpViewController : UIViewController {
    
    var sentTo: String?
    var user: AWSCognitoIdentityUser?
    
    @IBOutlet weak var sentToLabel: UILabel!
    
    @IBOutlet weak var code: UITextField!
    @IBOutlet var nextButtonSVGView: SVGView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sentToLabel.text = "Code sent to: \(self.sentTo!)"
        
        setupNextButton()
        setupTextField()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setProgress(4/5, animated: true)
        
        // This allows the keyboard to popup automatically
        code.becomeFirstResponder()
    }
    
    func setupNextButton() {
        nextButtonSVGView.backgroundColor = .clear
        nextButtonSVGView.isUserInteractionEnabled = true
        
        let nextScreenGesture = UITapGestureRecognizer.init(target: self, action: #selector(goForward))
        
        nextButtonSVGView.addGestureRecognizer(nextScreenGesture)
    }
    
    func setupTextField() {
        code.backgroundColor = UIColor.clear
        code.textColor = UIColor.white
        code.borderStyle = .none
        code.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
        code.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        code.keyboardAppearance = .dark
        code.keyboardType = .numberPad
    }
    
    func setupNavigationBar() {
        let barButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_white"), style: .plain, target: self, action: #selector(barButtonPressed))
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    @objc func barButtonPressed() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // handle confirm sign up
    
    @objc func goForward() {
        guard let confirmationCodeValue = self.code.text, !confirmationCodeValue.isEmpty else {
            let alertController = UIAlertController(title: "Confirmation code missing.",
                                                    message: "Please enter a valid confirmation code.",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion:  nil)
            return
        }
        self.user?.confirmSignUp(self.code.text!, forceAliasCreation: true).continueWith {[weak self] (task: AWSTask) -> AnyObject? in
            guard let strongSelf = self else { return nil }
            DispatchQueue.main.async(execute: {
                if let error = task.error as NSError? {
                    let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                            message: error.userInfo["message"] as? String,
                                                            preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    
                    strongSelf.present(alertController, animated: true, completion:  nil)
                } else {
                    
                    // Successfully signed up
                    strongSelf.navigationController?.finishProgress()
                    let constant = Constants()
                    strongSelf.present(constant.getMainContentVC(), animated: true, completion: nil)
        
                }
            })
            return nil
        }
    }
    
    // handle code resend action
    @IBAction func resend(_ sender: AnyObject) {
        self.user?.resendConfirmationCode().continueWith {[weak self] (task: AWSTask) -> AnyObject? in
            guard let _ = self else { return nil }
            DispatchQueue.main.async(execute: {
                if let error = task.error as NSError? {
                    let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                            message: error.userInfo["message"] as? String,
                                                            preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    
                    self?.present(alertController, animated: true, completion:  nil)
                } else if let result = task.result {
                    let alertController = UIAlertController(title: "Code Resent",
                                                            message: "Code resent to \(result.codeDeliveryDetails?.destination! ?? "no message")",
                        preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self?.present(alertController, animated: true, completion: nil)
                }
            })
            return nil
        }
    }
    
}
