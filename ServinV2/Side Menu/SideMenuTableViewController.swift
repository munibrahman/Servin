//
//  SideMenuTableViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-04.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import SideMenu

class SideMenuTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var optionsTableViewController: UITableView!
    
    var mainVC: MasterPulleyViewController? = nil
    
    let viewControllers = ["MessageViewController", "DropPin" , "MyPinsTableViewController", "SavedPinsViewController", "HelpViewController", "SettingsViewController"]
    let labels = ["Messages", "Drop a Pin", "My Pins", "Saved Pins", "Help", "Settings"]
    let icons = [#imageLiteral(resourceName: "messages_icon"), #imageLiteral(resourceName: "drop_pin_icon"), #imageLiteral(resourceName: "my_pin_icon"), #imageLiteral(resourceName: "savedPins_icon"), #imageLiteral(resourceName: "help_icon"), #imageLiteral(resourceName: "settings_icon")]
    
    fileprivate let reuseIdentifier = "NormalCell"
    fileprivate let profileCellReuseIdentifier = "ProfileCell"
    fileprivate let servinCellReuseIdentifier = "ServinCell"
    
    fileprivate var leftOverSpace: CGFloat = 0.0
    fileprivate let bottomProfileCellHeight: CGFloat = 84.0
    fileprivate let topCellHeight: CGFloat = 87.0
    fileprivate var cellHeight: CGFloat = 60.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionsTableViewController.delegate = self
        optionsTableViewController.dataSource = self
        
        optionsTableViewController.backgroundColor = UIColor.black
        
        self.view.backgroundColor = .white
        
        optionsTableViewController.register(UINib.init(nibName: "SideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        optionsTableViewController.register(UINib.init(nibName: "SideMenuProfileTableViewCell", bundle: nil), forCellReuseIdentifier: profileCellReuseIdentifier)
        optionsTableViewController.register(UINib.init(nibName: "SideMenuServinLogoTableViewCell", bundle: nil), forCellReuseIdentifier: servinCellReuseIdentifier)
        // Do any additional setup after loading the view.
        
        
        print("Top bar height with nav controller\(self.topbarHeight)")
        
        if let navVc = self.navigationController {
            print("Im inside a nav controller")
            navVc.navigationBar.isHidden = true
            
            print("Top bar height without nav controller\(self.topbarHeight)")
        }
        
        print("Screen height \(UIScreen.main.bounds.size.height)")
        print("My view heigt \(self.view.frame.size.height)")
        print("My status bar height \(self.statusBarHeight)")
        print("My table view's height \(self.optionsTableViewController.frame.size.height)")
        
        
        let totalSize = (cellHeight * CGFloat(icons.count)) + topCellHeight + bottomProfileCellHeight
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            let bottomPadding = window?.safeAreaInsets.bottom
            
            leftOverSpace = UIScreen.main.bounds.size.height - totalSize - self.statusBarHeight - (bottomPadding ?? 0.0)
        } else {
            leftOverSpace = UIScreen.main.bounds.size.height - totalSize - self.statusBarHeight
        }
        
        
        
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
//        // This is the height that our uitableview will sit inside of
//        allowedViewHeight = UIScreen.main.bounds.size.height - self.statusBarHeight
//
//        if #available(iOS 11.0, *) {
//            let window = UIApplication.shared.keyWindow
//            let topPadding = window?.safeAreaInsets.top
//            let bottomPadding = window?.safeAreaInsets.bottom
//
//            allowedViewHeight = UIScreen.main.bounds.size.height - (topPadding ?? 0.0) - (bottomPadding ?? 0.0)
//
//        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 6
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
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: profileCellReuseIdentifier, for: indexPath) as! SideMenuProfileTableViewCell
            cell.profileImageView.image = #imageLiteral(resourceName: "larry_avatar")
            cell.selectionStyle = .none
            cell.userNameLabel.text = "Larry"
            
            return cell
        }
        
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // This is the height that our uitableview will sit inside of
        
        
        switch indexPath.section {
        case 0:
            return topCellHeight
        case 1:
            
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
        print("row selected")
        
        if let mainViewController = mainVC {
            
            
            SideMenuManager.default.menuLeftNavigationController?.dismiss(animated: true, completion: {
                
                //                if indexPath.section == 1 && indexPath.row == 1 {
                //                    print("Logout")
                //                    mainViewController.present((self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController"))!, animated: true, completion: nil)
                //                } else {
                //                    let navController = UINavigationController.init(rootViewController: (self.storyboard?.instantiateViewController(withIdentifier: self.viewControllers[(indexPath.section * 4) + indexPath.row]))!)
                //
                //                    mainViewController.present(navController, animated: true, completion: nil)
                //                }
                
                
                switch indexPath.section {
                case 0:
                    print("Pressed on the servin logo")
                    return
                    
                case 1:
                    
                    switch indexPath.row {
                    case 1:
                        print("Drop a pin silly")
                        if let myVC = self.mainVC {
                            myVC.myMapViewController?.dropAPin()
                        }
                    default:
                        print("Open the correct VC")
                        
                        let navController = UINavigationController.init(rootViewController: (self.storyboard?.instantiateViewController(withIdentifier: self.viewControllers[indexPath.row]))!)
                        
                        mainViewController.present(navController, animated: true, completion: nil)
                    }
                    
                    
                default:
                    print("Open the profile VC")
                    let navController = UINavigationController.init(rootViewController: UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController"))
                    
                    mainViewController.present(navController, animated: true, completion: nil)
                }
                
                
            })
            
            
            
            
        }
        
        
        
        
        
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
