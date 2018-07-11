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

class ConfirmSignUpViewController : UIViewController, ChooseEmailActionSheetPresenter {
    
    var sentTo: String?
    var user: AWSCognitoIdentityUser?
    
    @IBOutlet weak var sentToLabel: UILabel!
    @IBOutlet var openEmailButton: UIButton!
    
    @IBOutlet var resendButton: UIButton!
    var chooseEmailActionSheet: UIAlertController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sentToLabel.text = "Code sent to: \(self.sentTo!)"
        
        // Instantiates the chosse email action sheet
        chooseEmailActionSheet = setupChooseEmailActionSheet()
        
        
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setProgress(4/5, animated: true)
        
        openEmailButton.borderWidth = 1.0
        openEmailButton.layer.cornerRadius = 5.0
        openEmailButton.clipsToBounds = true

        resendButton.titleLabel?.minimumScaleFactor = 0.5
        resendButton.titleLabel?.numberOfLines = 1
        resendButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
    
    func setupNavigationBar() {
        let barButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "x_white"), style: .plain, target: self, action: #selector(barButtonPressed))
        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    @objc func barButtonPressed() {
        // Dismiss the entire NavController instead of just dismissing itself.
        // At this point, the email has been registered, so no need to go back and view it all over again...
        self.navigationController?.finishProgress()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openEmailAction(_ sender: UIButton) {
        print("Pressed Open email")
        
        self.present(chooseEmailActionSheet!, animated: true) {
            print("Did successfully show options for choosing a mail client")
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
