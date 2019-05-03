//
//  ResetCodeSentViewController.swift
//  ServinV2
//
//  Created by Munib Rahman on 2019-05-02.
//  Copyright © 2019 Voltic Labs Inc. All rights reserved.
//

import Foundation
import UIKit
import AWSMobileClient

class ResetCodeSentViewController: UIViewController, ChooseEmailActionSheetPresenter {
    var chooseEmailActionSheet: UIAlertController?
    
    
    var titleLabel: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 43, weight: UIFont.Weight.light)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.text = "Check your email!"
        return label
    }()
    
    var subtitleLabel: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.light)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 3
        label.text = "We sent you a verification link, please open your email and follow the instructions."
        return label
    }()
    
    var openEmailButton: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.system)
        button.setTitle("Open Email App", for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.greyBackgroundColor, for: UIControl.State.normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 2.0
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        return button
    }()
    
    var emailSentToLabel: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.light)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.text = "Email sent to: "
        return label
    }()
    
    var resendConfirmation: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.system)
        button.setTitle("Didn't get an email yet? Resend Confirmation", for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: UIControl.State.normal)
        button.layer.cornerRadius = 2.0
        button.layer.masksToBounds = true
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        return button
    }()
    
    var userName: String! {
        didSet {
            emailSentToLabel.text = "Email sent to: \(userName!)"
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.greyBackgroundColor
    }
    
    override func viewDidLoad() {
        setupNavigationBar()
        setupViews()
    }
    
    func setupViews() {
        
        
        // Instantiates the chosse email action sheet
        chooseEmailActionSheet = setupChooseEmailActionSheet()
        
        view.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        view.addSubview(subtitleLabel)
        subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        
        view.addSubview(openEmailButton)
        openEmailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        openEmailButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 25).isActive = true
        openEmailButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        openEmailButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        openEmailButton.addTarget(self, action: #selector(didTapOpenEmail), for: UIControl.Event.touchUpInside)
        
        view.addSubview(emailSentToLabel)
        emailSentToLabel.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor).isActive = true
        emailSentToLabel.trailingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor).isActive = true
        emailSentToLabel.topAnchor.constraint(equalTo: openEmailButton.bottomAnchor, constant: 40).isActive = true
        
        view.addSubview(resendConfirmation)
        resendConfirmation.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor).isActive = true
        resendConfirmation.trailingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor).isActive = true
        resendConfirmation.topAnchor.constraint(equalTo: emailSentToLabel.bottomAnchor, constant: 8).isActive = true
        
        resendConfirmation.addTarget(self, action: #selector(didTapResend), for: UIControl.Event.touchUpInside)
    }
    
    @objc func didTapResend() {
        AWSMobileClient.sharedInstance().forgotPassword(username: userName) { (forgotPasswordResult, error) in
            if let forgotPasswordResult = forgotPasswordResult {
                switch(forgotPasswordResult.forgotPasswordState) {
                case .confirmationCodeSent:
                    
                    print("Confirmation code sent via \(forgotPasswordResult.codeDeliveryDetails!.deliveryMedium) to: \(forgotPasswordResult.codeDeliveryDetails!.destination!)")
                    
                    self.showSuccessNotification(title: "Success!", subtitle: "Link sent to \(self.userName ?? "your email")!")
                    
                default:
                    print("Error: Invalid case.")
                    self.showErrorNotification(title: "Error", subtitle: "Unable to send reset link, please try again.")
                }
            } else if let error = error {
                print("Error occurred: \(error.localizedDescription)")
                print(error)
                self.showErrorNotification(title: "Error", subtitle: "Unable to send reset link, please try again.")
            }
        }
    }
    
    @objc func didTapOpenEmail() {
        
        if let chooseEmailActionSheet = chooseEmailActionSheet {
            self.present(chooseEmailActionSheet, animated: true) {
                print("Did successfully show options for choosing a mail client")
            }
        }
    }
    
    func setupNavigationBar() {
        
        if navigationController?.viewControllers[0] == self {
            
            let leftBarItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "x_white"), style: .plain, target: self, action: #selector(userDidPressX))
            leftBarItem.tintColor = .white
            
            self.navigationItem.leftBarButtonItem = leftBarItem
            
        } else {
            
            let leftBarItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_white"), style: .plain, target: self, action: #selector(userDidPressBack))
            leftBarItem.tintColor = .white
            
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
    
}
