//
//  ReviewViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-07-30.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    let cellIdentifier = "CellIdentifer"
    
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
        
    }
    
    @objc func dismissViewController() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func setupViews()  {
        let layout = UICollectionViewFlowLayout.init()
        layout.estimatedItemSize = CGSize.init(width: 250, height: 300.0)
        
        let collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .red
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ReviewCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        self.view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }

}

extension ReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ReviewCollectionViewCell
        cell.backgroundColor = .blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.size.width, height: 300)
    }
    
}

private class ReviewCollectionViewCell: UICollectionViewCell {
    
    var profileImageView: UIImageView!
    var firstNameLabel: UILabel!
    var reviewDateLabel: UILabel!
    var reviewTextLabel: UILabel!
    
    
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
        firstNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        
        firstNameLabel.textColor = UIColor.blackFontColor
        
        self.contentView.addSubview(firstNameLabel)
        
        firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        firstNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8.0).isActive = true
        firstNameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        
        firstNameLabel.text = "Andrea"
        firstNameLabel.backgroundColor = .green
        
        
        reviewDateLabel = UILabel.init()
        
        self.contentView.addSubview(reviewDateLabel)
        
        reviewDateLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        reviewDateLabel.textColor = UIColor.blackFontColor
        
        reviewDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        reviewDateLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8.0).isActive = true
        reviewDateLabel.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor).isActive = true
        
//
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}






















