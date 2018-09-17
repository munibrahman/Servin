//
//  SideMenuTableViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-04.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import SideMenu
import AWSCognitoIdentityProvider
import Alamofire

class SideMenuTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var profileImageView: UIImageView?
    var userNameLabel: UILabel?
    
    @IBOutlet var optionsTableViewController: UITableView!
    
    var mainVC: MasterPulleyViewController? = nil
    
    let viewControllers = ["MessageViewController", "DropPin" , "MyPinsTableViewController", "SavedPinsViewController","Payments", "SettingsViewController"]
    let labels = ["Messages", "Drop a Pin", "My Pins", "Saved Pins", "Payment", "Settings"]
    let icons = [#imageLiteral(resourceName: "messages_icon"), #imageLiteral(resourceName: "drop_pin_icon"), #imageLiteral(resourceName: "my_pin_icon"), #imageLiteral(resourceName: "savedPins_icon"),#imageLiteral(resourceName: "payments_icon") , #imageLiteral(resourceName: "settings_icon")]
    
    fileprivate let reuseIdentifier = "NormalCell"
    fileprivate let profileCellReuseIdentifier = "ProfileCell"
    fileprivate let servinCellReuseIdentifier = "ServinCell"
    
    fileprivate var leftOverSpace: CGFloat = 0.0
    fileprivate let bottomProfileCellHeight: CGFloat = 84.0
    fileprivate let topCellHeight: CGFloat = 87.0
    fileprivate var cellHeight: CGFloat = 60.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        
        optionsTableViewController.delegate = self
        optionsTableViewController.dataSource = self
        
        optionsTableViewController.backgroundColor = UIColor.black
        
        self.view.backgroundColor = .white
        
        optionsTableViewController.register(UINib.init(nibName: "SideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        optionsTableViewController.register(UINib.init(nibName: "SideMenuProfileTableViewCell", bundle: nil), forCellReuseIdentifier: profileCellReuseIdentifier)
        optionsTableViewController.register(UINib.init(nibName: "SideMenuServinLogoTableViewCell", bundle: nil), forCellReuseIdentifier: servinCellReuseIdentifier)
        // Do any additional setup after loading the view.
        
        let totalSize = (cellHeight * CGFloat(icons.count)) + topCellHeight + bottomProfileCellHeight
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            let bottomPadding = window?.safeAreaInsets.bottom
            
            leftOverSpace = UIScreen.main.bounds.size.height - totalSize - self.statusBarHeight - (bottomPadding ?? 0.0)
        } else {
            leftOverSpace = UIScreen.main.bounds.size.height - totalSize - self.statusBarHeight
        }
        
        let user = AppDelegate.defaultUserPool().currentUser()

        if user != nil {
            user?.getDetails().continueOnSuccessWith(block: { (task) -> Any? in
                task.result?.userAttributes?.forEach({ (attribute) in
                    if attribute.name == "given_name" {
                        print("User's first name is \(attribute.value!)")
                    }
                })
            })
        }
        
        optionsTableViewController.backgroundColor = .red
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.userNameLabel?.text = DefaultsWrapper.getString(key: Key.givenName, defaultValue: "")
        self.profileImageView?.image = BackendServer.shared.fetchProfileImage()
    }
    
    func setupConstraints() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        optionsTableViewController.translatesAutoresizingMaskIntoConstraints = false
        optionsTableViewController.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        optionsTableViewController.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor).isActive = true
        optionsTableViewController.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        optionsTableViewController.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    
    // MARK: - DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 5
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: servinCellReuseIdentifier, for: indexPath) as! SideMenuServinLogoTableViewCell
            cell.selectionStyle = .none
            cell.imageView?.clipsToBounds = true
            cell.contentView.clipsToBounds = true
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SideMenuTableViewCell
            
            cell.selectionStyle = .none
            
            cell.menuOptionLabel.text = labels[indexPath.row]
            cell.menuOptionImageView.image = icons[indexPath.row]
            cell.menuOptionImageView.frame.origin.y = cell.menuOptionLabel.frame.origin.y
            cell.imageView?.clipsToBounds = true
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SideMenuTableViewCell
            
            cell.selectionStyle = .none
            
            cell.menuOptionLabel.text = labels.last
            cell.menuOptionImageView.image = icons.last
            cell.menuOptionImageView.frame.origin.y = cell.menuOptionLabel.frame.origin.y
            cell.imageView?.clipsToBounds = true
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: profileCellReuseIdentifier, for: indexPath) as! SideMenuProfileTableViewCell
            
            cell.selectionStyle = .none
            cell.userNameLabel.text = DefaultsWrapper.getString(key: Key.givenName, defaultValue: "")
            
            self.userNameLabel = cell.userNameLabel
            
            cell.profileImageView.image = BackendServer.shared.fetchProfileImage()
            
            
            self.profileImageView = cell.profileImageView
            
            
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // This is the height that our uitableview will sit inside of
        
        
        switch indexPath.section {
        case 0:
            return topCellHeight
        case 1:
            
            return cellHeight
            
        case 2:
            return cellHeight
            
        default:
            return bottomProfileCellHeight
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1.0
            
        } else if section == 1 {
            
            return leftOverSpace
        } else {
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 0 {
            let view = UIView.init()
            view.backgroundColor = UIColor.contentDivider
            return view
        } else {
            
            let footerView = UIView.init()
            footerView.backgroundColor = .white
            return footerView
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let mainViewController = mainVC {
            
            
            SideMenuManager.default.menuLeftNavigationController?.dismiss(animated: true, completion: {
            
                switch indexPath.section {
                case 0:
                    print("Pressed on the servin logo")
                    return
                    
                case 1:
                    
                    switch indexPath.row {
                        
                    case 0:
                        mainViewController.present(UINavigationController.init(rootViewController: MessageViewController()), animated: true, completion: nil)
                    case 1:
                        print("Drop a pin silly")
                        if let myVC = self.mainVC {
                            myVC.myMapViewController?.dropAPin()
                        }
                    case 4:
                        mainViewController.present(UINavigationController.init(rootViewController: PaymentViewController()), animated: true, completion: nil)
                    default:
                        print("Open the correct VC")
                        
                        let navController = UINavigationController.init(rootViewController: (self.storyboard?.instantiateViewController(withIdentifier: self.viewControllers[indexPath.row]))!)
                        
                        mainViewController.present(navController, animated: true, completion: nil)
                    }
                    
                    
                case 2:
                    

                        print("Open the correct VC")
                        
                        let navController = UINavigationController.init(rootViewController: (self.storyboard?.instantiateViewController(withIdentifier: self.viewControllers.last!))!)
                        
                        mainViewController.present(navController, animated: true, completion: nil)
                    
                    
                default:
                    print("Open the profile VC")
                    let navController = UINavigationController.init(rootViewController: UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController"))
                    
                    mainViewController.present(navController, animated: true, completion: nil)
                }
                
                
            })
            
        }
        
    }
    
}
