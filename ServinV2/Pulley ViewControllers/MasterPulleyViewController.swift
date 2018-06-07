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
    var mySlaveMapViewController: SlaveMapViewController?
    var mySlaveDiscoveriesViewController: SlaveDiscoveriesViewController?
    
    
    enum States {
        case normal
        case posting
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()

        self.drawerCornerRadius = 0.0
        self.backgroundDimmingColor = UIColor.white
        self.backgroundDimmingOpacity = 1.0
        
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
        
        
        // The constant is for the pulley view controller, its random, it works on both iphone x and the normal iphones...
        self.topInset = searchBar.frame.size.height + 14.0
        
    }
    
    var isShowingPostMenu = false
    var topBlurView: UIView! = nil
    
    func didLongPressOnMap(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        if isShowingPostMenu {
            // dont do anything, just ignore lol
            self.topBlurView.removeFromSuperview()
            self.topBlurView = nil
            
            UIView.animate(withDuration: 0.2, animations: {
                self.searchBar.transform = .identity
                
            }) { (completed) in
                
            }
            
            isShowingPostMenu = false
            
        } else {
            print("reciveing long press here")
            let top = CGAffineTransform(translationX: 0, y: -300)
            
            UIView.animate(withDuration: 0.2, animations: {
                self.searchBar.transform = top
            }) { (didComplete) in
                
                print(self.topbarHeight)
                self.topBlurView = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.topbarHeight + 120.0))
                let gradient = CAGradientLayer()
                gradient.frame = self.topBlurView.bounds
                gradient.colors = [UIColor.black.withAlphaComponent(0.8).cgColor, UIColor.clear.cgColor]
                self.self.topBlurView.layer.insertSublayer(gradient, at: 0)
                self.view.addSubview(self.topBlurView)
                self.isShowingPostMenu = true
                
                
//                let backButtonView = UIView.init(frame: CGRect.init(x: 20.0, y: self.topbarHeight + 15.0, width: 30.0, height: 30.0))
//                backButtonView.backgroundColor = .red
//                self.topBlurView.addSubview(backButtonView)
                
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
                
            }
        }
        
        
        
    }
    
    @objc func backPressed() {
        print("Back pressed")
    }

    
    
    @objc func postPressed() {
        print("Post pressed")
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
