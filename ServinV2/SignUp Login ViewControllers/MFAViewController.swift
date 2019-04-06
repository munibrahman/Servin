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
///

// Description: This view controller lets the user enter their MFA code, after they sign in, if MFA is enabled, they can use this screen to enter the code and proceed to the app.

import Foundation
import Macaw
import AWSMobileClient
import NotificationBannerSwift

class MFAViewController: UIViewController {
    
    var destination: String?
    
    @IBOutlet weak var sentTo: UILabel!
    @IBOutlet weak var confirmationCode: UITextField!
    @IBOutlet var nextButtonSVGView: GoForwardMacawView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sentTo.text = "Code sent to: \(self.destination!)"
        self.confirmationCode.text = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // perform any action, if required, once the view is loaded
        
        setupBackground()
        setupNavigationBar()
        setupTextField()
        setupNextButton()
    }
    
    func setupBackground() {
        self.view.backgroundColor = UIColor.greyBackgroundColor
    }
    
    func setupNavigationBar() {
        let barButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_white"), style: .plain, target: self, action: #selector(barButtonPressed))
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    
    @objc func barButtonPressed() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func setupTextField() {
        confirmationCode.backgroundColor = UIColor.clear
        confirmationCode.textColor = UIColor.white
        confirmationCode.borderStyle = .none
        confirmationCode.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
        confirmationCode.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        confirmationCode.keyboardType = .numberPad
        confirmationCode.keyboardAppearance = .dark
    }
    
    func setupNextButton() {
        
        let nextScreenGesture = UITapGestureRecognizer.init(target: self, action: #selector(goForward))
        
        nextButtonSVGView.addGestureRecognizer(nextScreenGesture)
    }
    
    
    
    @objc func goForward() {
        // check if the user is not providing an empty authentication code
        guard let authenticationCodeValue = self.confirmationCode.text, !authenticationCodeValue.isEmpty else {
            let alertController = UIAlertController(title: "Authentication Code Missing",
                                                    message: "Please enter the authentication code that was sent to \(self.destination ?? "your email or sms").",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion:  nil)
            return
        }
        AWSMobileClient.sharedInstance().confirmSignIn(challengeResponse: authenticationCodeValue) { (signInResult, error) in
            if let error = error  {
                print("\(error.localizedDescription)")
                self.showErrorNotification(title: "Error", subtitle: "\(error)")
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
                default:
                    self.showErrorNotification(title: "Error", subtitle: "Unable to sign in, please try again.")
                    print("\(signInResult.signInState.rawValue)")
                }
            }
        }
    }
    
}
