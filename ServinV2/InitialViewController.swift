//
//  InitialViewController.swift
//  ServinV2
//
//  Created by Munib Rahman on 2019-04-04.
//  Copyright © 2019 Voltic Labs Inc. All rights reserved.
//

// This is the very first view controller that is launched when the app is opened.
// In here, you must decide which screens to show based on the user's sign in status.

import UIKit
import AWSMobileClient

class InitialViewController: UIViewController {

    override func loadView() {
        view = UIView()
        view.backgroundColor = .red
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let welcomeVC = sb.instantiateViewController(withIdentifier: String.init(describing: WelcomeViewController.self))
        
        let userState = AWSMobileClient.sharedInstance().currentUserState
        switch (userState) {
        case .guest:
            self.present(welcomeVC, animated: true, completion: nil)
            print("user is in guest mode.")
        case .signedOut:
            // Present the welcome view controller.
            self.present(welcomeVC, animated: true, completion: nil)
            print("user signed out")
        case .signedIn:
            print("user is signed in.")
            // Present the actual app.
            let mainVC = Constants.getMainContentVC()
            self.present(mainVC, animated: true, completion: nil)
            
        case .signedOutUserPoolsTokenInvalid:
            self.present(welcomeVC, animated: true, completion: nil)
            print("need to login again.")
        case .signedOutFederatedTokensInvalid:
            
            print("user logged in via federation, but currently needs new tokens")
        default:
            // If everything fails, present the welcome vc.
            self.present(welcomeVC, animated: true, completion: nil)
            print("unsupported")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
