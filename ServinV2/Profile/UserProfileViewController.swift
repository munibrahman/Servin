//
//  UserProfileViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-06-19.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var firstNameLabel: UILabel!
    
    @IBOutlet var universityLabel: UILabel!
    @IBOutlet var aboutLabel: UILabel!
    
    @IBOutlet var aboutDescriptionLabel: UILabel!
    
    @IBOutlet var whatOthersSayLabel: UILabel!
    
    @IBOutlet var whatOthersSayDescriptionLabel: UILabel!
    
    @IBOutlet var readAllReviewsLabel: UILabel!
    
    @IBOutlet var memberSinceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if self.navigationController == nil {
            fatalError("This view controller must be presented within a UINavigationController")
        }
        
        
        setupViews()
        populateUserInfo()
    }
    
    func setupViews() {
        self.profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2.0
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        self.readAllReviewsLabel.isUserInteractionEnabled = true
        let readAllReviewsTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(userDidTapReadReviews))
        
        readAllReviewsLabel.addGestureRecognizer(readAllReviewsTapGesture)
        
        self.navigationController?.navigationBar.transparentNavigationBar()
        
        let backButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_grey"), style: .plain, target: self, action: #selector(userDidTapBack))
        backButton.tintColor = .black
        
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func populateUserInfo() {
        self.profileImageView.image = #imageLiteral(resourceName: "adriana")
        self.firstNameLabel.text = "Adriana"
        self.universityLabel.text = "University Of Calgary"
        self.aboutLabel.text = "About \(firstNameLabel.text ?? "")"
        self.aboutDescriptionLabel.text = "People find me to be an upbeat, self-motivated team player with excellent communication skills. For the past several years I have worked in lead qualification, telemarketing, and customer service in the technology industry. My experience includes successfully calling people in director-level positions of technology departments and developing viable leads. I have a track record of maintaining a consistent call and activity volume and consistently achieving the top 10 percent in sales, and I can do the same thing for your company."
        self.aboutDescriptionLabel.sizeToFit()
        
        self.whatOthersSayLabel.text = "What others say about \(firstNameLabel.text ?? "")"
        self.whatOthersSayDescriptionLabel.text = "Adriana was awesome! She helped me mow my lawn and it looks like new, she was on time and finished on time too! No issues whatsoever! I would highly recommend her for any other job! She completely surpassed my expectations!"
        
        self.memberSinceLabel.text = "2018"
        self.view.layoutIfNeeded()
    }

    @objc func userDidTapReadReviews() {
        print("Read all reviews tapped")
        
        let navController = UINavigationController.init(rootViewController: ReviewViewController())
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    @objc func userDidTapBack() {
        self.navigationController?.popViewController(animated: true)
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
