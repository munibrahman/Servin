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

// Description: This view controller is to be presented after a user has been signed up, and they still require the need to verify their email address.
// It allows them to open an email provider of their choice, so that they can click on the link and be taken to a verification place.

import Foundation
import Macaw
import AWSMobileClient
import NotificationBannerSwift

class ConfirmSignUpViewController : UIViewController, ChooseEmailActionSheetPresenter {
    
    var username: String?
    
    @IBOutlet weak var sentToLabel: UILabel!
    @IBOutlet var openEmailButton: UIButton!
    
    @IBOutlet var resendButton: UIButton!
    var chooseEmailActionSheet: UIAlertController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sentToLabel.text = "Code sent to: \(self.username!)"
        
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
        AWSMobileClient.sharedInstance().resendSignUpCode(username: username!, completionHandler: { (result, error) in
            if let signUpResult = result {
                // Show a success banner that the code was resent to the email provided
                DispatchQueue.main.async {
                    let banner = NotificationBanner.init(title: "Success", subtitle: "A verification code has been sent via \(signUpResult.codeDeliveryDetails!.deliveryMedium) to \(signUpResult.codeDeliveryDetails!.destination!)", leftView: nil, rightView: nil, style: BannerStyle.success, colors: nil)
                    banner.show()
                }
            } else if let error = error {
                print("\(error.localizedDescription)")
                // Show an error banner to the user
                DispatchQueue.main.async {
                    let banner = NotificationBanner.init(title: "Error", subtitle: "\(error)", leftView: nil, rightView: nil, style: BannerStyle.danger, colors: nil)
                    banner.show()
                }
            }
        })
    }
    
}
