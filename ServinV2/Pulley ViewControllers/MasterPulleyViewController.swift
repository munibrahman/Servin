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
        
        setDrawerPosition(position: .partiallyRevealed, animated: true)
        
//        self.shadowOpacity = 0.0
//        self.shadowRadius = 0.0
        // Do any additional setup after loading the view.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func setupSearchBar() {
        
        
        var topPadding: CGFloat = 10.0
        let sidepadding = topPadding
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            topPadding = topPadding + (window?.safeAreaInsets.top ?? 0.0)
            
        }
        
        let searchBar = DummySearchView.init(frame: CGRect.init(x: sidepadding , y: topPadding + 20.0, width: self.view.frame.size.width - (sidepadding * 2), height: 50.0), daddyVC: self)
        
        // Setting the search bar's frame to be used by the search
        // view controller
        Constants.searchBarFrame = searchBar.frame
        
        self.view.addSubview(searchBar)
        
        
        self.topInset = 10.0 + searchBar.frame.size.height
        
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
