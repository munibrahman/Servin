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
import AWSAppSync

class InitialViewController: UIViewController {

    var servinLogo: UIImageView = {
        
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "login_logo_servin")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.greyBackgroundColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(servinLogo)
        servinLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        servinLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        servinLogo.widthAnchor.constraint(equalToConstant: 116).isActive = true
        servinLogo.heightAnchor.constraint(equalToConstant: 210).isActive = true

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
            checkIfselectedCategories()
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
    
    // This is a very critical part of this application. If all the checks don't go right, nothing opens. So ensure that all else cases are taken care of.
    func checkIfselectedCategories() {
        
        print("Checking to see if categories have been selected")
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let appSyncClient = appDelegate.appSyncClient
            
            appSyncClient?.fetch(query: MeQuery(), cachePolicy: CachePolicy.fetchIgnoringCacheData, resultHandler: { (result, error) in
                
                if error != nil {
                    print("Error fetching my own query")
                    print(error?.localizedDescription ?? "Can't unwrap error")
                    // Present the actual app.
                    DispatchQueue.main.async {
                        self.present(Constants.getMainContentVC(), animated: true, completion: nil)
                    }
                    return
                } else if let result = result {
                    if let chosen = result.data?.me?.hasChosenCategories {
                        if chosen {
                            // Present the actual app.
                            DispatchQueue.main.async {
                                self.present(Constants.getMainContentVC(), animated: true, completion: nil)
                            }
                        } else {
                            // Present the categories.
                            DispatchQueue.main.async {
                                let navVC = UINavigationController.init(rootViewController: SelectCategoriesViewController())
                                self.present(navVC, animated: true, completion: nil)
                            }
                        }
                    } else {
                        // Can't unwrap the chosen boolean, maybe first time, just show the categories.
                        DispatchQueue.main.async {
                            let navVC = UINavigationController.init(rootViewController: SelectCategoriesViewController())
                            self.present(navVC, animated: true, completion: nil)
                        }
                    }
                } else {
                    // Can't unwrap anything, just show the app
                    DispatchQueue.main.async {
                        self.present(Constants.getMainContentVC(), animated: true, completion: nil)
                    }
                }
                
            })
        } else {
            // Present the actual app.
            DispatchQueue.main.async {
                self.present(Constants.getMainContentVC(), animated: true, completion: nil)
            }
            
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
