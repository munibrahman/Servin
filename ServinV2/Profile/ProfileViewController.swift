//
//  ProfileViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-05.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import Alamofire
import AWSCognitoIdentityProvider

class ProfileViewController: UIViewController {
    
    
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var firstNameLabel: UILabel!
    @IBOutlet var creditsLabel: UILabel!
    @IBOutlet var aboutMeLabel: UILabel!
    @IBOutlet var othersSayAboutMeLabel: UILabel!
    @IBOutlet var memberSinceLabel: UILabel!
    @IBOutlet var schoolLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        setupNavigationController()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showAlertView(alertType: UIViewController.Alert.error, message: "No internet connection", duration: 3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupViews()
    }
    
    func setupViews() {
        
        firstNameLabel.text = DefaultsWrapper.getString(key: Key.givenName, defaultValue: "")
        
        creditsLabel.text = "14,000 servin credits"
        
        
        aboutMeLabel.text = DefaultsWrapper.getString(key: Key.aboutMe, defaultValue: "")
        aboutMeLabel.numberOfLines = 0
        aboutMeLabel.sizeToFit()
        
        othersSayAboutMeLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"
        othersSayAboutMeLabel.numberOfLines = 0
        othersSayAboutMeLabel.sizeToFit()
        
        schoolLabel.text = DefaultsWrapper.getString(key: Key.school, defaultValue: "")
        
        
        self.profileImageView.image = BackendServer.shared.fetchProfileImage()
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2.0

        
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2.0
        profileImageView.clipsToBounds = true
    }
    
    func setupNavigationController() {
        navigationController?.navigationBar.tintColor = UIColor.black
        
        let barButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "x_white"), style: .plain, target: self, action: #selector(barButtonPressed))
        navigationItem.leftBarButtonItem = barButtonItem
        
        navigationController?.navigationBar.topItem?.title = "My Profile"
        
        let editButtonItem = UIBarButtonItem.init(title: "Edit", style: .plain, target: self, action: #selector(showEditVC))
        
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    @objc func barButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func showEditVC() {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        
        if let vc = sb.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController {
            let navController = UINavigationController.init(rootViewController: vc)
            
            self.present(navController, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
