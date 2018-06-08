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
import GoogleMaps

class MasterPulleyViewController: PulleyViewController, SlaveMapViewControllerDelegate {

    
    var searchBar: SearchView!
    
    var myMapViewController: SlaveMapViewController?
    var myDiscoveriesViewController: SlaveDiscoveriesViewController?
    var myPostAdViewController: SlavePostAdViewController?
    
    
    enum States {
        case normal
        case posting
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()


        
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
  
        let topPadding = self.topbarHeight + 15.0
        
        
        searchBar = SearchView.init(frame: CGRect.init(x: 0.0 , y: topPadding, width: self.view.frame.size.width, height: 40.0), daddyVC: self)
        
        // Setting the search bar's frame to be used by the search
        // view controller
        Constants.searchBarFrame = searchBar.frame
        
        self.view.addSubview(searchBar)
        
        
        
        // The small shrug when you pull the drawer all the way to the top is 20.0 points, so 15 allows u to keep it just below the
        self.topInset = topPadding + searchBar.frame.size.height - 15.0
        
        self.backgroundDimmingColor = UIColor.white
        self.backgroundDimmingOpacity = 1.0
    }
    

    var isShowingPostMenu = false
    
    // This method is called when someone long presses on the main map
    func didLongPressOnMap(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        if isShowingPostMenu {
            // dont do anything, just jot down the new coordinate, thats it.
            
        } else {
            drawerShouldShow(postAd: true)
        }
        
    }


    var topBlurView: UIView! = nil
    
    func drawerShouldShow(postAd: Bool) {
        
        // If the user did a long press onto the map, we will be posting the ad.
        // Show the appropriate view for posting an ad.
        if postAd {
            
            // We are showing the posting menu
            self.isShowingPostMenu = true
            
            // If we are asking the user to fill their info, we don't need the drawer to animate
            self.backgroundDimmingColor = UIColor.clear
            
            let top = CGAffineTransform(translationX: 0, y: -300)
            
            UIView.animate(withDuration: 0.2, animations: {
                
                // Hide the search bar
                self.searchBar.transform = top
            }) { (didComplete) in
                
                print(self.topbarHeight)
                self.topBlurView = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.topbarHeight + 120.0))
                let gradient = CAGradientLayer()
                gradient.frame = self.topBlurView.bounds
                gradient.colors = [UIColor.black.withAlphaComponent(0.8).cgColor, UIColor.clear.cgColor]
                self.self.topBlurView.layer.insertSublayer(gradient, at: 0)
                self.view.addSubview(self.topBlurView)
                
                
                let backButton = UIButton.init(frame: CGRect.init(x: 17.0, y: self.topbarHeight + 15.0, width: 30.0, height: 30.0))
                backButton.setImage(#imageLiteral(resourceName: "x_white"), for: .normal)
                self.topBlurView.addSubview(backButton)
                
                let backTap = UITapGestureRecognizer.init(target: self, action: #selector(self.backPressed))
                backButton.addGestureRecognizer(backTap)
                
                let postButton = UIButton.init(frame: CGRect.init(x: self.view.frame.size.width - 17.0 - 50.0, y: self.topbarHeight + 15.0, width: 50.0, height: 30.0))
                postButton.setTitle("Post", for: .normal)
                postButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
                
                let postTap = UITapGestureRecognizer.init(target: self, action: #selector(self.postPressed))
                postButton.addGestureRecognizer(postTap)
                
                self.topBlurView.addSubview(postButton)
                
                
                
                if let postAdDrawer = self.myPostAdViewController {
                    self.setDrawerPosition(position: .partiallyRevealed, animated: false)
                    self.setDrawerContentViewController(controller: postAdDrawer)
                    
                    
                    //setNeedsSupportedDrawerPositionsUpdate()
                } else {
                    fatalError("My post drawer is empty, this should never happen")
                }
                
                
                
            }
            
        }
        
        // The user just backed out of posting an ad OR they actually did post the ad.
        else {
            
            // We are not showing the posting menu, we are shoing the discoveries instead.
            isShowingPostMenu = false
            
//            self.drawerCornerRadius = 0.0
            self.backgroundDimmingColor = UIColor.white
            self.backgroundDimmingOpacity = 1.0
            
            self.topBlurView.removeFromSuperview()
            self.topBlurView = nil
            
            UIView.animate(withDuration: 0.2, animations: {
                self.searchBar.transform = .identity
                
            }) { (completed) in
                
            }
            
            if let discoveriesVC = myDiscoveriesViewController {
                self.setDrawerContentViewController(controller: discoveriesVC)
            }
            
            // This clears the pin from the map
            if let mapVC = self.primaryContentViewController as? SlaveMapViewController {
                mapVC.homeMapView.clear()
            }
            
            
        }
        
    }
    
    
    @objc func backPressed() {
        print("Back pressed")
        drawerShouldShow(postAd: false)
        
    }

    @objc func postPressed() {
        print("Post pressed")
    }
    
    override func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat) {
        super.drawerPositionDidChange(drawer: drawer, bottomSafeArea: bottomSafeArea)
        
        print("Changed position of drawer")
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
