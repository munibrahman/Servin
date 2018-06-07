//
//  SearchView.swift
//  ServinV2
//
//  Created by Developer on 2018-05-05.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import SideMenu

class SearchView: UIView {
    
    var daddyVC: UIViewController! = nil
    let sidePadding: CGFloat = 20.0

    init(frame: CGRect, daddyVC: MasterPulleyViewController) {
        super.init(frame: frame)
        
        // This is the hamburger menu icon.
        let menuIcon = UIImageView.init(frame: CGRect.init(x: sidePadding, y: (frame.size.height / 2.0) - 10.0, width: 20.0, height: 20.0))
        menuIcon.image = #imageLiteral(resourceName: "menu_icon")
        menuIcon.contentMode = .scaleAspectFit
        menuIcon.isUserInteractionEnabled = false
        
        let menuIconSpace: CGFloat = menuIcon.frame.size.width + (sidePadding * 2.0)
        
        let menuTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(menuTapped))
        let menuTapView = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: menuIconSpace, height: self.frame.size.height))
        menuTapView.backgroundColor = .clear
        menuTapView.isUserInteractionEnabled = true
        menuTapView.addGestureRecognizer(menuTapGesture)
        
        self.addSubview(menuIcon)
        self.addSubview(menuTapView)

        
       
        
        let searchBar = UIView.init(frame: CGRect.init(x: menuIconSpace, y: 0.0, width: self.frame.size.width - menuIconSpace - sidePadding, height: self.frame.size.height))
        searchBar.backgroundColor = .white
        
        let radius: CGFloat = searchBar.frame.width / 2.0 //change it to .height if you need spread for height
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 2.0 * radius, height: frame.height))
        //Change 2.1 to amount of spread you need and for height replace the code for height
        
        searchBar.layer.cornerRadius = 2
        searchBar.layer.shadowColor = UIColor.black.cgColor
        searchBar.layer.shadowOffset = CGSize(width: 0.5, height: 0.4)  //Here you control x and y
        searchBar.layer.shadowOpacity = 0.5
        searchBar.layer.shadowRadius = 5.0 //Here your control your blur
        searchBar.layer.masksToBounds =  false
        searchBar.layer.shadowPath = shadowPath.cgPath
        
        self.addSubview(searchBar)
        
        let discoverLabel = UILabel.init(frame: searchBar.frame.offsetBy(dx: 10.0, dy: 0.0))
        discoverLabel.text = "Discover"
        discoverLabel.adjustsFontSizeToFitWidth = true
        discoverLabel.font = UIFont(name: "HelveticaNeue", size: 21.0)!
        discoverLabel.textColor = UIColor.init(red: 174.0/255.0, green: 174.0/255.0, blue: 174.0/255.0, alpha: 1.0)
        discoverLabel.isUserInteractionEnabled = true
        discoverLabel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapPressed)))
        self.addSubview(discoverLabel)
        
        
        
        self.daddyVC = daddyVC
    }
    
    @objc func tapPressed() {
        print("tapped")
        
        self.daddyVC.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapSearchViewController"), animated: false, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func menuTapped () {
        daddyVC.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    
    // This search bar sits inside the search view controller.
    
    var searchTextField = UITextField()
    
    init(frame: CGRect, daddyVC: MapSearchViewController) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        // This is the hamburger menu icon.
        let menuIcon = UIImageView.init(frame: CGRect.init(x: sidePadding, y: (frame.size.height / 2.0) - 10.0, width: 20.0, height: 20.0))
        menuIcon.image = #imageLiteral(resourceName: "<_black")
        menuIcon.contentMode = .scaleAspectFit
        menuIcon.isUserInteractionEnabled = false
        
        let menuIconSpace: CGFloat = menuIcon.frame.size.width + (sidePadding * 2.0)
        
        let menuTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.backPressed))
        let menuTapView = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: menuIconSpace, height: self.frame.size.height))
        menuTapView.backgroundColor = .clear
        menuTapView.isUserInteractionEnabled = true
        menuTapView.addGestureRecognizer(menuTapGesture)
        
        self.addSubview(menuIcon)
        self.addSubview(menuTapView)
        
        
        
        
        let searchBar = UIView.init(frame: CGRect.init(x: menuIconSpace, y: 0.0, width: self.frame.size.width - menuIconSpace - sidePadding, height: self.frame.size.height))
        searchBar.backgroundColor = .white
        
        let radius: CGFloat = searchBar.frame.width / 2.0 //change it to .height if you need spread for height
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 2.0 * radius, height: frame.height))
        //Change 2.1 to amount of spread you need and for height replace the code for height
        
        searchBar.layer.cornerRadius = 2
        searchBar.layer.shadowColor = UIColor.black.cgColor
        searchBar.layer.shadowOffset = CGSize(width: 0.5, height: 0.4)  //Here you control x and y
        searchBar.layer.shadowOpacity = 0.5
        searchBar.layer.shadowRadius = 5.0 //Here your control your blur
        searchBar.layer.masksToBounds =  false
        searchBar.layer.shadowPath = shadowPath.cgPath
        
        self.addSubview(searchBar)
        
        
        
        searchTextField = UITextField.init(frame: searchBar.frame.insetBy(dx: 10.0, dy: 0.0))
        //searchView.placeholder = "Try house cleaning..."
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Try: House Cleaning...", attributes:[NSAttributedStringKey.foregroundColor: UIColor.init(red: 174.0/255.0, green: 174.0/255.0, blue: 174.0/255.0, alpha: 1.0)])
        searchTextField.adjustsFontSizeToFitWidth = true
        searchTextField.font = UIFont(name: "HelveticaNeue", size: 21.0)!
        searchTextField.textColor = UIColor.black
        searchTextField.clearButtonMode = .whileEditing
        self.addSubview(searchTextField)
        
        
        
        self.daddyVC = daddyVC
    }
    
    
    
    @objc func backPressed() {
        print("tapped")
        
        if daddyVC != nil {
            self.daddyVC.dismiss(animated: false, completion: nil)
        } else {
            print("Daddy vc is nil, somthing is wrong...")
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

