//
//  MasterPulleyViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-21.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

// This view controller is the actual PulleyVC, the search bar will rest on this view controller.

import UIKit
import Pulley

class MasterPulleyViewController: PulleyViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()

        self.drawerCornerRadius = 0.0
        self.backgroundDimmingColor = UIColor.white
        self.backgroundDimmingOpacity = 1.0
        
        
//        self.shadowOpacity = 0.0
//        self.shadowRadius = 0.0
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setDrawerPosition(position: .partiallyRevealed, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSearchBar() {
        
        
        var topPadding: CGFloat = 10.0
        let sidepadding = topPadding
        
        
        if #available(iOS 11.0, *) {
            
            // User has ios 11
            let window = UIApplication.shared.keyWindow
            
            if let tp = window?.safeAreaInsets.top {
                // Using an iPhone X
                if tp != 0.0 {
                    topPadding = tp
                } else {
                    topPadding = 20.0
                }
            }
        } else {
            topPadding = 20.0
        }
        
        let searchBar = DummySearchView.init(frame: CGRect.init(x: sidepadding , y: topPadding + 20.0, width: self.view.frame.size.width - (sidepadding * 2), height: 50.0), daddyVC: self)
        
        // Setting the search bar's frame to be used by the search
        // view controller
        Constants.searchBarFrame = searchBar.frame
        
        self.view.addSubview(searchBar)
        
        
        // The constant is random, it works on both iphone x and the normal iphones...
        self.topInset = searchBar.frame.size.height + 14.0
        
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
