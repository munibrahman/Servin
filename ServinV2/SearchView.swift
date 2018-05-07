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

    init(frame: CGRect, daddyVC: ViewController) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        let menuButton = UIImageView.init(frame: CGRect.init(x: 15.0, y: (frame.size.height / 2.0) - 10.0, width: 20.0, height: 20.0))
        menuButton.image = #imageLiteral(resourceName: "menu_icon")
        menuButton.contentMode = .scaleAspectFit
        
        let menuTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(menuTapped))
        menuButton.isUserInteractionEnabled = true
        menuButton.addGestureRecognizer(menuTapGesture)
        
        self.addSubview(menuButton)

        
        let discoverLabel = UILabel.init(frame: CGRect.init(x: 60.0, y: 0.0, width: frame.size.width - 60.0, height: frame.size.height))
        discoverLabel.text = "Discover"
        discoverLabel.adjustsFontSizeToFitWidth = true
        discoverLabel.font = UIFont(name: "HelveticaNeue", size: 21.0)!
        discoverLabel.textColor = UIColor.init(red: 174.0/255.0, green: 174.0/255.0, blue: 174.0/255.0, alpha: 1.0)
        discoverLabel.isUserInteractionEnabled = true
        discoverLabel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapPressed)))
        self.addSubview(discoverLabel)
        
        let radius: CGFloat = frame.width / 2.0 //change it to .height if you need spread for height
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 2.0 * radius, height: frame.height))
        //Change 2.1 to amount of spread you need and for height replace the code for height
        
        self.layer.cornerRadius = 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.5, height: 0.4)  //Here you control x and y
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5.0 //Here your control your blur
        self.layer.masksToBounds =  false
        self.layer.shadowPath = shadowPath.cgPath
        
        self.daddyVC = daddyVC
    }
    
    @objc func tapPressed() {
        print("tapped")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func menuTapped () {
        daddyVC.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

