//
//  SlaveDiscoveriesViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-21.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import Pulley

class SlaveDiscoveriesViewController: UIViewController, UIScrollViewDelegate, PulleyDrawerViewControllerDelegate {

    var scrollView: UIScrollView! = nil
    var scrollViewHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView.init(frame: self.view.bounds)
        
        let myNearbyPins = PinsNearbyView.init(frame: CGRect.init(x: 0, y: 15, width: self.view.frame.size.width, height: 212))
        
        let myRecommendations = RecommendedPinsView.init(frame: CGRect.init(x: 0, y: 212 + 30, width: self.view.frame.width, height: (240.0 * 5.0) + 35 + 20.0))
        
        scrollView.addSubview(myNearbyPins)
        scrollView.addSubview(myRecommendations)
        
        
        // TODO: Calculate the actual height here
        scrollViewHeight = (212.0 + (240 * 5) + 200 + 35)
        scrollView.contentSize = CGSize.init(width: self.view.frame.size.width, height: scrollViewHeight)
        scrollView.scrollsToTop = true

        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.bounces = false
        
        scrollView.delegate = self
        
        
        // This ensures that you dont get extra spacing at the top when you try and scroll down.
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        self.view.addSubview(scrollView)
        
        
//        self.view.addSubview(myNearbyPins)
//        self.view.addSubview(myRecommendations)
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // We listen to the drawer's position and then disable/enable scrolling of the scroll view by
    // adjusting its content size
    func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat) {
        
        if drawer.drawerPosition == .open {
            scrollView.contentSize = CGSize.init(width: scrollView.contentSize.width, height: scrollViewHeight)
        } else {
            scrollView.contentSize = CGSize.init(width: scrollView.contentSize.width, height: 0)
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
