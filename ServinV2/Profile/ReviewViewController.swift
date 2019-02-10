//
//  ReviewViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-07-30.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ReviewViewController: UIViewController {
    
    let cellIdentifier = "CellIdentifer"
    let headerID = "headerId"
    
    fileprivate let reviewArray = [Review.init(name: "Andrea", timeAgo: "2 weeks ago", review: "Couldn't have asked for a better cook! Larry is amazing when it comes to the culinary arts! He made my breakfast without issues and helped me clean up after. Would definetly recommend"), Review.init(name: "Simon", timeAgo: "6 weeks ago", review: "My lawn looks brand new thanks to larry. He was on time and ready to roll, no issues at all. 10/10"), Review.init(name: "Moe", timeAgo: "3 months", review: "Thank you larry for helping me with MATH 271, i aced my exam thanks to your help. :)")]
    
    override func loadView() {
        view = UIView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupNavigationBar()
        setupViews()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavigationBar() {
        
        if self.navigationController == nil {
            fatalError()
        }
        
        if self.navigationController?.viewControllers[0] != self {
            fatalError("Nav controller can only have 1 child")
        }
        
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "x_white"), style: .plain, target: self, action: #selector(dismissViewController))
        leftBarButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        self.navigationController?.navigationBar.transparentNavigationBar()
        
    }
    
    @objc func dismissViewController() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func setupViews()  {
        let layout = UICollectionViewFlowLayout.init()
        layout.estimatedItemSize = CGSize.init(width: 250, height: 300)
        layout.headerReferenceSize = CGSize.init(width: 250, height: 100)
        
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        //collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(ReviewCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
        
        
        self.view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }

}

extension ReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ReviewCollectionViewCell
        
        cell.firstNameLabel.text = reviewArray[indexPath.row].name
        cell.reviewDateLabel.text = reviewArray[indexPath.row].timeAgo
        cell.reviewTextView.text = reviewArray[indexPath.row].review
        
        
        Alamofire.request("https://9z2epuh1wa.execute-api.us-east-1.amazonaws.com/dev/user/picture").responseImage { (response) in
            
            if let image = response.result.value {
                cell.profileImageView.image = image
            }
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize.init(width: collectionView.frame.size.width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        
        let estimatedTitleFrame = NSString.init(string: reviewArray[indexPath.row].review).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .regular)], context: nil)
        
        return CGSize.init(width: collectionView.frame.size.width, height: estimatedTitleFrame.size.height + 100)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.row == 0 {
            var v : UICollectionReusableView! = nil
            if kind == UICollectionView.elementKindSectionHeader {
                v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.headerID, for: indexPath)
                if v.subviews.count == 0 {
                    v.addSubview(UILabel(frame:CGRect.init(x: 0, y: 0, width: collectionView.frame.size.width, height: v.frame.size.height)))
                }
                let lab = v.subviews[0] as! UILabel
                lab.font = UIFont.systemFont(ofSize: 28, weight: .bold)
                lab.textColor = UIColor.blackFontColor
                lab.textAlignment = .left
                
                // TODO: Show actual reviews
                lab.text = "\(reviewArray.count) \(reviewArray.count > 1 ? "Reviews" : "Review")"
            }
            return v
        }
        
        return UICollectionReusableView()
    }
    
}

private class ReviewCollectionViewCell: UICollectionViewCell {
    
    var profileImageView: UIImageView!
    var firstNameLabel: UILabel!
    var reviewDateLabel: UILabel!
    var reviewTextView: UITextView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        profileImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2.0
        profileImageView.clipsToBounds = true
        
        profileImageView.backgroundColor = .white
        
        self.contentView.addSubview(profileImageView)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        firstNameLabel = UILabel.init()
        firstNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        firstNameLabel.textColor = UIColor.blackFontColor
        
        firstNameLabel.textColor = UIColor.blackFontColor
        
        self.contentView.addSubview(firstNameLabel)
        
        firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        firstNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8.0).isActive = true
        firstNameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        
        firstNameLabel.text = "Andrea"
        firstNameLabel.textColor = UIColor.blackFontColor
        
        reviewDateLabel = UILabel()
        self.contentView.addSubview(reviewDateLabel)
        
        reviewDateLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewDateLabel.leadingAnchor.constraint(equalTo: firstNameLabel.leadingAnchor).isActive = true
        reviewDateLabel.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 4.0).isActive = true
        
        reviewDateLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        reviewDateLabel.text = "2 weeks ago"
        reviewDateLabel.textColor = UIColor.blackFontColor
        
        reviewTextView = UITextView()
        
        reviewTextView.isUserInteractionEnabled = false
        
        self.contentView.addSubview(reviewTextView)
        
        reviewTextView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        reviewTextView.textColor = UIColor.blackFontColor
        
        reviewTextView.translatesAutoresizingMaskIntoConstraints = false
        
        reviewTextView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        reviewTextView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12.0).isActive = true
        reviewTextView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        reviewTextView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        reviewTextView.text = "Could have not asked for a better person to work on my lawn, Larry was on time and punctual. He moved everything down "
        reviewTextView.textColor = UIColor.blackFontColor
        reviewTextView.textContainerInset = .zero
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class Review {
    
    var name: String!
    var timeAgo: String!
    var review: String!
    
    init(name: String, timeAgo: String, review: String) {
        self.name = name
        self.timeAgo = timeAgo
        self.review = review
    }
    
}




















