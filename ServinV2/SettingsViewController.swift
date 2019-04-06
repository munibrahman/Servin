//
//  SettingsViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-05.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
//import AWSCognitoIdentityProvider
import Eureka
import AWSMobileClient


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
                    return InviteOthersViewController()
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
            <<< ButtonRow("Payment") {
                $0.title = $0.tag
                $0.presentationMode = PresentationMode.show(controllerProvider: ControllerProvider.callback(builder: { () -> UIViewController in
                    return PaymentViewController()
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
                    return MFASettingsViewController()
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
                    
                    
                    let actionController = UIAlertController.init(title: "Are you sure?", message: nil, preferredStyle: UIAlertController.Style.alert)
                    
                    let cancel = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
                    let logout = UIAlertAction.init(title: "Logout", style: UIAlertAction.Style.destructive, handler: { (action) in
                        print("Sign out")

                        // TODO: Use AWSMobileClient, sign out, clear everything and show the very first screen.
                        AWSMobileClient.sharedInstance().signOut()
                        
                        print("Signed out the person")
                        DefaultsWrapper.removeEverything()
                        KeyChainStore.shared.removeAllKeys()
                        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                        
//                        if let user = AppDelegate.defaultUserPool().currentUser() {
//                            user.signOutAndClearLastKnownUser()
//                            DefaultsWrapper.removeEverything()
//                            KeyChainStore.shared.removeAllKeys()
//                            print("Signed out the user")
//                            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
//                        }
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
    
    var progressBarButton: UIBarButtonItem!
    var backButton: UIBarButtonItem!
    
    override func loadView() {
        view = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        
        setupViews()
        setupNavBar()
        
        self.navigationItem.title = "Change Password"
    }
    
    func setupViews() {
        
        let progressSpinner = UIActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        progressSpinner.color = UIColor.black
        progressSpinner.startAnimating()
        
        progressBarButton = UIBarButtonItem.init(customView: progressSpinner)
        
        
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
        currentPassword.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16.0).isActive = true
        currentPassword.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16.0).isActive = true
        currentPassword.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 20.0).isActive = true
        currentPassword.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        
        newPassword.translatesAutoresizingMaskIntoConstraints = false
        newPassword.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16.0).isActive = true
        newPassword.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16.0).isActive = true
        newPassword.topAnchor.constraint(equalTo: currentPassword.bottomAnchor).isActive = true
        newPassword.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        newPasswordConfirm.translatesAutoresizingMaskIntoConstraints = false
        newPasswordConfirm.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16.0).isActive = true
        newPasswordConfirm.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16.0).isActive = true
        newPasswordConfirm.topAnchor.constraint(equalTo: newPassword.bottomAnchor).isActive = true
        newPasswordConfirm.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
    
    
    var doneButton: UIBarButtonItem!
    
    func setupNavBar() {
        doneButton = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(changePassword))
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func changePassword() {
        // TODO: Send password request here.
        
        guard let currentText = currentPassword.text, !currentText.isEmpty else {
            
            currentPassword.errorText = "This field can't be left empty"
            currentPassword.showError()
            return
        }
        
        guard let newText = newPassword.text, !newText.isEmpty else {
            
            newPassword.errorText = "This field can't be left empty"
            newPassword.showError()
            return
        }
        
        guard let newTextConfirm = newPasswordConfirm.text, !newTextConfirm.isEmpty else {
            
            newPasswordConfirm.errorText = "This field can't be left empty"
            newPasswordConfirm.showError()
            
            return
        }
        
        if newText != newTextConfirm {
            
            newPassword.showError()
            
            
            newPasswordConfirm.errorText = "The passwords do not match"
            newPasswordConfirm.showError()
            
            return
        }
        
        self.navigationItem.rightBarButtonItem = progressBarButton
        

        // TODO: AWSMobileClient to reset the password
//        AppDelegate.defaultUserPool().currentUser()?.changePassword(currentPassword.text!, proposedPassword: newPassword.text!).continueWith(block: { [weak self] (task: AWSTask) -> Any? in
//            guard let strongSelf = self else {return nil}
//            DispatchQueue.main.async(execute: {
//
//                strongSelf.navigationItem.rightBarButtonItem = strongSelf.doneButton
//
//                if let error = task.error as NSError? {
//
//
//                    let alertController = UIAlertController(title: "Error",
//                                                            message: error.userInfo["message"] as? String,
//                                                            preferredStyle: .alert)
//                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                    alertController.addAction(okAction)
//
//                    strongSelf.present(alertController, animated: true, completion:  nil)
//                } else {
//
//                    strongSelf.navigationController?.popViewController(animated: true)
//
//                }
//            })
//            return nil
//        })
        
        
    }
    
}


private class MFASettingsViewController: UIViewController {
    
    var mfaSwitch: UISwitch!
//    var mfaSettings:[AWSCognitoIdentityProviderMFAOptionType]?
//    var userAttributes:[AWSCognitoIdentityProviderAttributeType]?
//    var user:AWSCognitoIdentityUser?
    
    override func loadView() {
        view = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViews()
        setupNavigationBar()
        loadUserValues()
    }
    
    func setupViews() {
        mfaSwitch = UISwitch.init()
//
        self.view.addSubview(mfaSwitch)

        mfaSwitch.translatesAutoresizingMaskIntoConstraints = false
        mfaSwitch.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8.0).isActive = true
        mfaSwitch.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 8.0).isActive = true

        mfaSwitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch) {
        
        print("switch value did change")
        
//        let settings = AWSCognitoIdentityUserSettings()
//        if mfaSwitch.isOn {
//            // Enable MFA
//            let mfaOptions = AWSCognitoIdentityUserMFAOption()
//            mfaOptions.attributeName = "phone_number"
//            mfaOptions.deliveryMedium = .sms
//            settings.mfaOptions = [mfaOptions]
//        } else {
//            // Disable MFA
//            settings.mfaOptions = []
//        }
//
//         user?.setUserSettings(settings)
//            .continueWith(block: { (response) -> Any? in
//                if response.error != nil {
//                    let alert = UIAlertController(title: "Error", message: (response.error! as NSError).userInfo["message"] as? String, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                    self.present(alert, animated: true, completion:nil)
//                    self.resetAttributeValues()
//                } else {
//                    self.fetchUserAttributes()
//                }
//                return nil
//            })
    }
    
    func setupNavigationBar() {
        
        self.view.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .never

    }
    
    func loadUserValues() {
        self.resetAttributeValues()
        self.fetchUserAttributes()
    }
    
    func fetchUserAttributes() {
        self.resetAttributeValues()
        // TODO: AWSMobileClient to setup mfa
//        user = AppDelegate.defaultUserPool().currentUser()
//        user?.getDetails().continueOnSuccessWith(block: { (task) -> Any? in
//            guard task.result != nil else {
//                return nil
//            }
//            self.userAttributes = task.result?.userAttributes
//            self.mfaSettings = task.result?.mfaOptions
//            self.userAttributes?.forEach({ (attribute) in
//                print("Name: " + attribute.name!)
//            })
//            DispatchQueue.main.async {
//                self.setAttributeValues()
//            }
//            return nil
//        })
    }
    
    func isEmailMFAEnabled() -> Bool {
//        let values = self.mfaSettings?.filter { $0.deliveryMedium == AWSCognitoIdentityProviderDeliveryMediumType.sms }
//        if values?.first != nil {
//            return true
//        }
        return false
    }
    
    func resetAttributeValues() {
        DispatchQueue.main.async {
            self.mfaSwitch.setOn(false, animated: false)
        }
    }
    
    func setAttributeValues() {
        DispatchQueue.main.async {
//            if self.mfaSettings == nil {
//                self.mfaSwitch.setOn(false, animated: false)
//            } else {
//                self.mfaSwitch.setOn(self.isEmailMFAEnabled(), animated: false)
//            }
        }
    }
    
}













































