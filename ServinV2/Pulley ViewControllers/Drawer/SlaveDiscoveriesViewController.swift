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
        
        let myRecommendations = RecommendedPinsView.init(frame: CGRect.init(x: 0, y: 212 + 30, width: self.view.frame.width, height: 1000))
        
        scrollView.addSubview(myNearbyPins)
        scrollView.addSubview(myRecommendations)
        
        
        // TODO: Calculate the actual height here
        scrollViewHeight = 2000.0
        scrollView.contentSize = CGSize.init(width: self.view.frame.size.width, height: scrollViewHeight)
        scrollView.scrollsToTop = true

        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.bounces = false
        
        scrollView.delegate = self
        
        self.view.addSubview(scrollView)
        
        
//        self.view.addSubview(myNearbyPins)
//        self.view.addSubview(myRecommendations)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat) {
        
        if drawer.drawerPosition == .open {
            scrollView.contentSize = CGSize.init(width: scrollView.contentSize.width, height: scrollViewHeight)
        } else {
            scrollView.contentSize = CGSize.init(width: scrollView.contentSize.width, height: 0)
        }
        
        print("Drawer inside discoveries did change")
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            print("down")
        } else {
            print("up")
        }
        
        print()
        print(scrollView.panGestureRecognizer.translation(in: scrollView))
        print()
        
        print(scrollView.gestureRecognizers)
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        print("scrolled to top")
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
