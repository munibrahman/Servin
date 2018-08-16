//
//  SettingsViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-05.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider
import Eureka


// TODO: Come in here and add views for all the settings...
class SettingsViewController: FormViewController {
    
    let cellIdentifier = "cell"
    let logoutCellIdentifier = "LogoutCell"
    
    let sections = ["Invite", "Rewards", "Account", "Notifications", "Support", "About", "Logins"]
    let invite = ["Invite Your Friends"]
    let rewards = ["Redeem Servin Credits"]
    let account = [ "Password", "Payment Methods", "Payout Methods", "Transaction History", "Multi Factor Authentication"]
    let notifications = ["Push Notifications", "Email and SMS Notifications"]
    let support = ["Help Center", "Report a Problem", "Submit Feedback"]
    let about = ["Ads", "Data Policy", "Open Source Libraries", "Terms"]
    let logins = ["Log Out"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = .none
        
        // Do any additional setup after loading the view.
        setupNavigationController()
        
        form
            
            +++ Section() { section in
                var header = HeaderFooterView<SettingsTableView>(.class)
                header.height = {50}
                header.onSetupView = { view, _ in
                    view.titleLabel.text = "Invite"
                }
                section.header = header
                
                var footer = HeaderFooterView<ContentDividerView>(.class)
                footer.height = {1}
                
                section.footer = footer
            }
            
            <<< ButtonRow("Invite Your Friends") {
                $0.title = $0.tag
                $0.presentationMode = PresentationMode.show(controllerProvider: ControllerProvider.callback(builder: { () -> UIViewController in
                    return RandomViewController()
                }), onDismiss: { (vc) in
                    vc.navigationController?.popViewController(animated: true)
                    print("vc did run")
                })
            }
        
            +++ Section() { section in
                var header = HeaderFooterView<SettingsTableView>(.class)
                header.height = {50}
                header.onSetupView = { view, _ in
                    view.titleLabel.text = "Rewards"
                }
                section.header = header
                
                var footer = HeaderFooterView<ContentDividerView>(.class)
                footer.height = {1}
                
                section.footer = footer
            }
            
            <<< ButtonRow("Redeem Servin Credits") {
                $0.title = $0.tag
                $0.presentationMode = PresentationMode.show(controllerProvider: ControllerProvider.callback(builder: { () -> UIViewController in
                    return RandomViewController()
                }), onDismiss: nil)
                
            }
            
            <<< ButtonRow("Servin Balance") {
                $0.title = $0.tag
                $0.presentationMode = PresentationMode.show(controllerProvider: ControllerProvider.callback(builder: { () -> UIViewController in
                    return RandomViewController()
                }), onDismiss: nil)
                
            }
        
            +++ Section() { section in
                var header = HeaderFooterView<SettingsTableView>(.class)
                header.height = {50}
                header.onSetupView = { view, _ in
                    view.titleLabel.text = "Account"
                }
                section.header = header
                
                var footer = HeaderFooterView<ContentDividerView>(.class)
                footer.height = {1}
                
                section.footer = footer
            }
            
            <<< ButtonRow("Password") {
                $0.title = $0.tag
                $0.presentationMode = PresentationMode.show(controllerProvider: ControllerProvider.callback(builder: { () -> UIViewController in
                    return ChangePasswordViewController()
                }), onDismiss: nil)
                
            }
            <<< ButtonRow("Payment Methods") {
                $0.title = $0.tag
                $0.presentationMode = PresentationMode.show(controllerProvider: ControllerProvider.callback(builder: { () -> UIViewController in
                    return PaymentMethodsViewController()
                }), onDismiss: nil)
                
            }
            
            <<< ButtonRow("Payout Methods") {
                $0.title = $0.tag
                $0.presentationMode = PresentationMode.show(controllerProvider: ControllerProvider.callback(builder: { () -> UIViewController in
                    return PayoutMethodsViewController()
                }), onDismiss: nil)
                
            }
        
        
            <<< ButtonRow("Transaction History") {
                $0.title = $0.tag
                $0.presentationMode = PresentationMode.show(controllerProvider: ControllerProvider.callback(builder: { () -> UIViewController in
                    return RandomViewController()
                }), onDismiss: nil)
                
            }
        
            <<< ButtonRow("Multifactor Authentication") {
                $0.title = $0.tag
                $0.presentationMode = PresentationMode.show(controllerProvider: ControllerProvider.callback(builder: { () -> UIViewController in
                    return RandomViewController()
                }), onDismiss: nil)
                
            }
        
        
        
            +++ Section() { section in
                var header = HeaderFooterView<SettingsTableView>(.class)
                header.height = {50}
                header.onSetupView = { view, _ in
                    view.titleLabel.text = "Notifications"
                }
                section.header = header
                
                var footer = HeaderFooterView<ContentDividerView>(.class)
                footer.height = {1}
                
                section.footer = footer
            }
            
            <<< ButtonRow("Push Notifications") {
                $0.title = $0.tag
                $0.presentationMode = PresentationMode.show(controllerProvider: ControllerProvider.callback(builder: { () -> UIViewController in
                    return RandomViewController()
                }), onDismiss: nil)
                
            }
        
            <<< ButtonRow("Email and SMS Notifications") {
                $0.title = $0.tag
                $0.presentationMode = PresentationMode.show(controllerProvider: ControllerProvider.callback(builder: { () -> UIViewController in
                    return RandomViewController()
                }), onDismiss: nil)
                
            }
        
            +++ Section() { section in
                var header = HeaderFooterView<SettingsTableView>(.class)
                header.height = {50}
                header.onSetupView = { view, _ in
                    view.titleLabel.text = "Support"
                }
                section.header = header
                
                var footer = HeaderFooterView<ContentDividerView>(.class)
                footer.height = {1}
                
                section.footer = footer
            }
            
            <<< ButtonRow("Help Center") {
                $0.title = $0.tag
                $0.presentationMode = PresentationMode.show(controllerProvider: ControllerProvider.callback(builder: { () -> UIViewController in
                    return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HelpViewController")
                }), onDismiss: nil)
                
            }
            
            <<< ButtonRow("Report a Problem") {
                $0.title = $0.tag
                $0.presentationMode = PresentationMode.show(controllerProvider: ControllerProvider.callback(builder: { () -> UIViewController in
                    return RandomViewController()
                }), onDismiss: nil)
                
            }
        
            <<< ButtonRow("Submit Feedback") {
                $0.title = $0.tag
                $0.presentationMode = PresentationMode.show(controllerProvider: ControllerProvider.callback(builder: { () -> UIViewController in
                    return RandomViewController()
                }), onDismiss: nil)
                
            }
        
            +++ Section() { section in
                var header = HeaderFooterView<SettingsTableView>(.class)
                header.height = {50}
                header.onSetupView = { view, _ in
                    view.titleLabel.text = "About"
                }
                section.header = header
                
                var footer = HeaderFooterView<ContentDividerView>(.class)
                footer.height = {1}
                
                section.footer = footer
            }
            
            <<< ButtonRow("Ads") {
                $0.title = $0.tag
                $0.presentationMode = PresentationMode.show(controllerProvider: ControllerProvider.callback(builder: { () -> UIViewController in
                    return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HelpViewController")
                }), onDismiss: nil)
                
            }
            
            <<< ButtonRow("Data Policy") {
                $0.title = $0.tag
                $0.presentationMode = PresentationMode.show(controllerProvider: ControllerProvider.callback(builder: { () -> UIViewController in
                    return RandomViewController()
                }), onDismiss: nil)
                
            }
            
            <<< ButtonRow("Open Source Libraries") {
                $0.title = $0.tag
                $0.presentationMode = PresentationMode.show(controllerProvider: ControllerProvider.callback(builder: { () -> UIViewController in
                    return RandomViewController()
                }), onDismiss: nil)
                
                }
            
            <<< ButtonRow("Terms") {
                $0.title = $0.tag
                $0.presentationMode = PresentationMode.show(controllerProvider: ControllerProvider.callback(builder: { () -> UIViewController in
                    return RandomViewController()
                }), onDismiss: nil)
                
        }
        
        
        
            +++ Section() { section in
                var header = HeaderFooterView<SettingsTableView>(.class)
                header.height = {50}
                header.onSetupView = { view, _ in
                    view.titleLabel.text = "Logins"
                }
                section.header = header
                
                var footer = HeaderFooterView<ContentDividerView>(.class)
                footer.height = {1}
                
                section.footer = footer
            }
            
            <<< ButtonRow("Log Out from this device") {
                $0.title = $0.tag
                
                }.cellUpdate({ (cell, row) in
                    cell.textLabel?.textAlignment = .left
                    cell.textLabel?.textColor = UIColor.red
                }).onCellSelection({ (cell, row) in
                    
                    
                    let actionController = UIAlertController.init(title: "Are you sure?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancel = UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
                    let logout = UIAlertAction.init(title: "Logout", style: UIAlertActionStyle.destructive, handler: { (action) in
                        print("Sign out")
                        
                        if let user = AppDelegate.defaultUserPool().currentUser() {
                            user.signOutAndClearLastKnownUser()
                            print("Signed out the user")
                            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                        }
                    })
                    
                    actionController.addAction(cancel)
                    actionController.addAction(logout)
                    
                    self.present(actionController, animated: true, completion: nil)
                    
                    
                    
                })
    }
    
    
    func setupNavigationController() {
        
        navigationItem.title = "Settings"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.largeTitleDisplayMode = .automatic
        
        
        navigationController?.navigationBar.tintColor = UIColor.black
        
        let barButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "x_white"), style: .plain, target: self, action: #selector(barButtonPressed))
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    @objc func barButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


class LogOutTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let logoutLabel = UILabel.init()
        
        logoutLabel.textColor = UIColor.init(red: 1.0, green: 0.231372549, blue: 0.1882352941, alpha: 1.0)
        logoutLabel.text = "Log Out"
        logoutLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        logoutLabel.textAlignment = .center
        
        contentView.backgroundColor = .white
        contentView.addSubview(logoutLabel)
        
        logoutLabel.translatesAutoresizingMaskIntoConstraints = false

        logoutLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        logoutLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        logoutLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        logoutLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class SettingsTableView: UIView {
    
    var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel.init(frame: CGRect.init(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height))
        //titleLabel.frame.offsetBy(dx: 14.0, dy: 0.0)
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        titleLabel.textColor = UIColor.black
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.backgroundColor = .white
        self.addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14.0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        //self.addSubview(arrowView)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ContentDividerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.contentDivider
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




class RandomViewController: UIViewController {
    
    override func loadView() {
        view = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .never
    }
}


class ChangePasswordViewController : UIViewController, UITextFieldDelegate {
    
    var currentPassword: CustomFloatingTextfield!
    var newPassword: CustomFloatingTextfield!
    var newPasswordConfirm: CustomFloatingTextfield!
    
    override func loadView() {
        view = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        
        setupViews()
        setupNavBar()
    }
    
    func setupViews() {
        currentPassword = CustomFloatingTextfield.init()
        newPassword = CustomFloatingTextfield.init()
        newPasswordConfirm = CustomFloatingTextfield.init()
        
        currentPassword.placeholder = "Current Password"
        newPassword.placeholder = "New Password"
        newPasswordConfirm.placeholder = "One more time"
        
        currentPassword.isSecureTextEntry = true
        newPassword.isSecureTextEntry = true
        newPasswordConfirm.isSecureTextEntry = true
        
        currentPassword.selectedPlaceHolderColor = .lightGray
        newPassword.selectedPlaceHolderColor = .lightGray
        newPasswordConfirm.selectedPlaceHolderColor = .lightGray
        
        currentPassword.clearButtonMode = .always
        newPassword.clearButtonMode = .always
        newPasswordConfirm.clearButtonMode = .always
        
        
        view.addSubview(currentPassword)
        view.addSubview(newPassword)
        view.addSubview(newPasswordConfirm)
        
        currentPassword.translatesAutoresizingMaskIntoConstraints = false
        currentPassword.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12.0).isActive = true
        currentPassword.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        currentPassword.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 20.0).isActive = true
        currentPassword.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        
        newPassword.translatesAutoresizingMaskIntoConstraints = false
        newPassword.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12.0).isActive = true
        newPassword.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        newPassword.topAnchor.constraint(equalTo: currentPassword.bottomAnchor).isActive = true
        newPassword.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        newPasswordConfirm.translatesAutoresizingMaskIntoConstraints = false
        newPasswordConfirm.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12.0).isActive = true
        newPasswordConfirm.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        newPasswordConfirm.topAnchor.constraint(equalTo: newPassword.bottomAnchor).isActive = true
        newPasswordConfirm.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
    
    
    func setupNavBar() {
        let nextButton = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(updatePassword))
        self.navigationItem.rightBarButtonItem = nextButton
    }
    
    @objc func updatePassword() {
        // TODO: Send password request here.
        
        self.navigationController?.popViewController(animated: true)
    }
    
}







