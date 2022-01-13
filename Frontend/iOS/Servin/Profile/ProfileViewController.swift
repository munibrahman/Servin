//
//  ProfileViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-05.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import AWSAppSync
import AWSS3

class ProfileViewController: UIViewController {
    
    
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var firstNameLabel: UILabel!
    @IBOutlet var aboutMeLabel: UILabel!
    @IBOutlet var othersSayAboutMeLabel: UILabel!
    @IBOutlet var memberSinceLabel: UILabel!
    @IBOutlet var schoolLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        setupNavigationController()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupViews()
    }
    
    func setupViews() {
        
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let appSyncClient = appDelegate.appSyncClient
            
            appSyncClient?.fetch(query: MeQuery(), cachePolicy: CachePolicy.returnCacheDataAndFetch, resultHandler: { (result, error) in
                
                if error != nil || result?.errors != nil {
                    print(result?.errors)
                    print(error?.localizedDescription ?? "Can't unwrap error")
                    return
                }
                
                if let me = result?.data?.me {
                    self.firstNameLabel?.text = me.givenName
                    self.aboutMeLabel.text = me.about
                    self.schoolLabel.text = me.school
                    
                    if var time = me.signUpDate {
                        time = time / 1000.0
                        print(time)
                        let formatter = DateFormatter()
                        // initially set the format based on your datepicker date / server String
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        
                        let myString = formatter.string(from: Date.init(timeIntervalSince1970: time)) // string purpose I add here
                        // convert your string to date
                        let yourDate = formatter.date(from: myString)
                        //then again set the date format whhich type of output you need
                        formatter.dateFormat = "MMM yyyy"
                        // again convert your date to string
                        let myStringafd = formatter.string(from: yourDate!)
                        
                        print(myStringafd)
                        
                        self.memberSinceLabel.text = myStringafd
                        
                    }
                    
                    
                } else {
                    print("Can't unwrap the me object, show error")
                }
                
                
                
            })
        }
        
        
        aboutMeLabel.numberOfLines = 0
        aboutMeLabel.sizeToFit()
        
        othersSayAboutMeLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation"
        othersSayAboutMeLabel.numberOfLines = 0
        othersSayAboutMeLabel.sizeToFit()
        
        // TODO: Fetch image from your own s3 bucket
        self.profileImageView.loadImageUsingS3Key(key: S3ProfileImageKeyName)
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2.0

        self.view.layoutIfNeeded()
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
