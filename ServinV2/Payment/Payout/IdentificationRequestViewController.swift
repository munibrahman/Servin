//
//  IdentificationRequestViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-08-16.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import Foundation
import UIKit

class IdentificationRequestViewController: UIViewController {
    
    override func loadView() {
        view = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        if self.navigationController == nil {
            fatalError("Must be presented inside a navigation controller")
        }
        
        setupNavigationBar()
        setupViews()
        
    }
    
    func setupNavigationBar() {
        
        
        if navigationController?.viewControllers[0] == self {
            print("I am the base view controller")
            
            let leftBarItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "x_white"), style: .plain, target: self, action: #selector(userDidPressX))
            leftBarItem.tintColor = .black
            
            self.navigationItem.leftBarButtonItem = leftBarItem
            
        } else {
            print("I am presented on someone else")
            
            let leftBarItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_white"), style: .plain, target: self, action: #selector(userDidPressBack))
            leftBarItem.tintColor = .black
            
            self.navigationItem.leftBarButtonItem = leftBarItem
        }
        
        
        
        
        self.navigationController?.navigationBar.transparentNavigationBar()
    }
    
    @objc func userDidPressX() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func userDidPressBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupViews() {
        let topLabel = UILabel.init()
        view.addSubview(topLabel)
        
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        topLabel.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 16).isActive = true
        topLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        
        topLabel.text = "Take a photo of your personal identification"
        topLabel.font = UIFont.systemFont(ofSize: 34, weight: .regular)
        topLabel.textColor = UIColor.blackFontColor
        topLabel.numberOfLines = 2
        
        topLabel.sizeToFit()
        
        
        let descriptionLabel = UILabel.init()
        view.addSubview(descriptionLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        
        
        descriptionLabel.text = "You can use your driver's license, please ensure that that the flash is off and the text is legible."
        descriptionLabel.textColor = UIColor.blackFontColor.withAlphaComponent(0.9)
        descriptionLabel.font = UIFont.systemFont(ofSize: 21, weight: .regular)
        descriptionLabel.numberOfLines = 5
        
        descriptionLabel.sizeToFit()
        
        
        let continueButton = UIButton.init()
        view.addSubview(continueButton)
        
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        continueButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -30).isActive = true
        continueButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        continueButton.backgroundColor = UIColor.greyBackgroundColor
        
        continueButton.layer.cornerRadius = 30
        continueButton.clipsToBounds = true
        
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setImage(#imageLiteral(resourceName: ">_pink_background"), for: .normal)
        continueButton.semanticContentAttribute = .forceRightToLeft
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 21)
        continueButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 10)
        continueButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -10)
        
        continueButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(userDidTapContinue)))
        
    }
    
    @objc func userDidTapContinue() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = false
        vc.delegate = self
        vc.navigationBar.tintColor = .white
        present(vc, animated: true, completion: nil)
    }
    
    
}

extension IdentificationRequestViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("No image found")
            return
        }
        
        // print out the image size as a test
        print(image.size)
    }
    
}









































