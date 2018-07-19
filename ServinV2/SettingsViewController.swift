//
//  SettingsViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-05.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

class SettingsViewController: UIViewController {
    
    @IBOutlet var settingsTableView: UITableView!
    
    let cellIdentifier = "cell"
    let logoutCellIdentifier = "LogoutCell"
    
    let sections = ["Rewards", "Invite", "Device", "Account", "About", nil]
    let rewards = ["Redeem Servin Credits"]
    let invite = ["Invite Members", "Submit Feedback", "About"]
    let device = [ "Push Notifications"]
    let account = [ "Password", "Payment History", "Payment History", "Payment Information"]
    let about = ["Legal"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        
        settingsTableView.separatorStyle = .none
        
        settingsTableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        settingsTableView.register(LogOutTableViewCell.self, forCellReuseIdentifier: logoutCellIdentifier)
        // Do any additional setup after loading the view.
        setupNavigationController()
        
        
    }
    
    func signOut() {
        AppDelegate.defaultUserPool().currentUser()?.signOutAndClearLastKnownUser()
    }
    
    
    func setupNavigationController() {
        
        navigationItem.title = "Settings"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
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



extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 || section == 2 || section == 4 || section == 5 {
            return 1
        } else if section == 1 || section == 3 {
            return 3
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == sections.count - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: logoutCellIdentifier) as! LogOutTableViewCell
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SettingsTableViewCell
        
        var label = ""
        
        switch indexPath.section {
        case 0:
            label = rewards[indexPath.row]
        case 1:
            label = invite[indexPath.row]
        case 2:
            label = device[indexPath.row]
        case 3:
            label = account[indexPath.row]
        case 4:
            label = about[indexPath.row]
        default:
            label = ""
        }
        
        cell.titleLabel.text = label
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init()
        view.backgroundColor = UIColor.contentDivider
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34.0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.backgroundView?.backgroundColor = .white
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == sections.count - 1 {
            
            print("logged out")
            
            let alertController = UIAlertController.init(title: "Are you sure?", message: nil, preferredStyle: .alert)
            
            let cancelAlertAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
            
            let yesAlertAction = UIAlertAction.init(title: "Log Out", style: .destructive) { (didFinish) in
                
                
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
                    (appDelegate.window?.rootViewController as? UINavigationController)?.popToRootViewController(animated: true)
                    self.signOut()
                }
            }
            
            alertController.addAction(yesAlertAction)
            alertController.addAction(cancelAlertAction)
            
            self.present(alertController, animated: true, completion: nil)

            
        }
    }
    
    
}


class SettingsTableViewCell: UITableViewCell {
    
    var titleLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel = UILabel.init(frame: CGRect.init(x: 14.0, y: 0.0, width: contentView.frame.size.width - 14.0, height: contentView.frame.size.height))
        titleLabel.frame.offsetBy(dx: 14.0, dy: 0.0)
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = UIColor.blackFontColor
        
        let arrowView = UIImageView.init()
        
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowView)
        
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        arrowView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        arrowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.0).isActive = true
        arrowView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        
        arrowView.image = #imageLiteral(resourceName: ">_grey")
        arrowView.contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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



















