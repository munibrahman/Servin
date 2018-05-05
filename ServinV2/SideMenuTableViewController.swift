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
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    
    var mainVC: UIViewController! = nil
    
    let viewControllers = ["MessageViewController", "MyPinsViewController", "ProfileViewController", "HelpViewController", "SettingsViewController", "LoginViewController"]
    let labels = ["Messages", "My Pins", "Profile", "Help", "Settings", "Logout"]
    let icons = [#imageLiteral(resourceName: "messages_icon"), #imageLiteral(resourceName: "pins_icon"), #imageLiteral(resourceName: "profile_icon"), #imageLiteral(resourceName: "help_icon"), #imageLiteral(resourceName: "settings_icon"), #imageLiteral(resourceName: "logout_icon")]
    
    fileprivate let reuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        optionsTableViewController.delegate = self
        optionsTableViewController.dataSource = self
        
        optionsTableViewController.backgroundColor = UIColor.white
        
        optionsTableViewController.register(UINib.init(nibName: "SideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
        
        setupImageView()
    }
    
    func setupImageView() {
        userImageView.layer.cornerRadius = userImageView.frame.width / 2.0
        
        userImageView.layer.masksToBounds = true
        
        userImageView.contentMode = .scaleAspectFit
        userImageView.image = #imageLiteral(resourceName: "larry_avatar")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SideMenuTableViewCell
        
        cell.selectionStyle = .none
        
        cell.menuOptionLabel.text = labels[(indexPath.section * 4) + indexPath.row]
        cell.imageView?.image = icons[(indexPath.section * 4) + indexPath.row]
        
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return self.view.frame.height / 4.0
        } else {
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init()
        view.backgroundColor = .white
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let gradientView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 1.0))
        
        gradientView.image = #imageLiteral(resourceName: "linear_gradient")
        
        return gradientView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height / 12
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row selected")
        
        
        SideMenuManager.default.menuLeftNavigationController?.dismiss(animated: true, completion: {
            if indexPath.section == 1 && indexPath.row == 1 {
                print("Logout")
                self.mainVC.present((self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController"))!, animated: true, completion: nil)
            } else {
                let navController = UINavigationController.init(rootViewController: (self.storyboard?.instantiateViewController(withIdentifier: self.viewControllers[(indexPath.section * 4) + indexPath.row]))!)
                
                self.mainVC.present(navController, animated: true, completion: nil)
            }
        })
        
    
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
