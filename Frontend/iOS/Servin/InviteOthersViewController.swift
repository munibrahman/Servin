//
//  InviteOthersViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-09-12.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import Foundation
import UIKit

class InviteOthersViewController: UIViewController {
    
    override func loadView() {
        view = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        
        setupNavigationBar()
        setupViews()
        
    }
    
    
    func setupNavigationBar() {
        
        if self.navigationController?.viewControllers.first == self {
            let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "x_white"), style: .plain, target: self, action: #selector(userDidTapX))
            leftBarButton.tintColor = .black
            self.navigationItem.leftBarButtonItem = leftBarButton
        } else {
            let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_grey"), style: .plain, target: self, action: #selector(userDidTapBack))
            leftBarButton.tintColor = .black
            self.navigationItem.leftBarButtonItem = leftBarButton
        }
        
        self.navigationController?.navigationBar.backgroundColor = .white
        
        
    }
    
    
    func setupViews() {
        let titleView = UILabel.init()
        titleView.font = UIFont.systemFont(ofSize: 33, weight: .semibold)
        titleView.numberOfLines = 2
        titleView.textColor = UIColor.blackFontColor
        titleView.text = "Give $7 CAD, get $7 CAD"
        
        self.view.addSubview(titleView)
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        let descriptionView = UILabel.init()
        descriptionView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionView.textColor = UIColor.blackFontColor.withAlphaComponent(0.8)
        descriptionView.text = "When someone signs up for Servin with your link, they'll get $7 CAD in spending credit. \n\nOnce they've spent more than $15 in services, you'll get $7 CAD in credit."
        
        view.addSubview(descriptionView)
        
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        descriptionView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 10).isActive = true
        descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        descriptionView.numberOfLines = 0
        
        
        
        let shareButton = UIButton.init()
        shareButton.setTitle("Share your link", for: .normal)
        shareButton.setTitleColor(.white, for: .normal)
        
        shareButton.backgroundColor = UIColor.greyBackgroundColor
        
        shareButton.layer.cornerRadius = 4.0
        shareButton.clipsToBounds = true
        
        view.addSubview(shareButton)
        
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        
        shareButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        shareButton.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 40).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        
        shareButton.addTarget(self, action: #selector(shareLink), for: .touchDown)
        
        
    }
    
    @objc func shareLink() {
        let activityItem = URL.init(string: "http://servin.io/")
        
        let activityVC = UIActivityViewController.init(activityItems: [activityItem], applicationActivities: nil)
        
        present(activityVC, animated: true, completion: nil)
    }
    
    @objc func userDidTapX() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func userDidTapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
