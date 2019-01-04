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
import SideMenu
import Alamofire

class MasterPulleyViewController: PulleyViewController, SlaveMapViewControllerDelegate {
    
    var searchBar: SearchView!
    
    var myMapViewController: SlaveMapViewController?
    var myDiscoveriesViewController: SlaveDiscoveriesViewController?
    var myPostAdViewController: SlavePostAdViewController?
    
    var postBarButton: UIBarButtonItem!
    var progressBarButton: UIBarButtonItem!
    
    enum States {
        case normal
        case posting
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupSideMenu()
        setupNavigationBar()
        
        // Do any additional setup after loading the view.
        
        
    }
    
    func setupSideMenu() {
        
        let sideMenuTableVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenuTableViewController") as! SideMenuTableViewController
        sideMenuTableVC.mainVC = self
        let menuLeftVC = UISideMenuNavigationController.init(rootViewController: sideMenuTableVC)
        
        menuLeftVC.navigationController?.navigationBar.tintColor = UIColor.white
        
        menuLeftVC.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        menuLeftVC.navigationController?.navigationBar.shadowImage = UIImage()
        menuLeftVC.navigationController?.navigationBar.isTranslucent = true
        SideMenuManager.default.menuLeftNavigationController = menuLeftVC
        
        
        SideMenuManager.default.menuLeftNavigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        SideMenuManager.default.menuLeftNavigationController?.navigationBar.shadowImage = UIImage()
        SideMenuManager.default.menuLeftNavigationController?.navigationBar.isTranslucent = true
        
        SideMenuManager.default.menuFadeStatusBar = false
        
        SideMenuManager.default.menuWidth = view.frame.width * (0.8)
        
    }
    
    func setupNavigationBar() {
        
        if self.navigationController == nil {
            fatalError("Must be presented inside a UINavigationController")
        }
        
         self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.navigationController?.navigationBar.transparentNavigationBar()
        
        let leftItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "x_white"), style: .plain, target: self, action: #selector(userDidTapX))
        leftItem.tintColor = .white
        
        postBarButton = UIBarButtonItem.init(title: "Post", style: .plain, target: self, action: #selector(userDidTapPost))
        postBarButton.tintColor = .white
        
        self.navigationItem.leftBarButtonItem = leftItem
        self.navigationItem.rightBarButtonItem = postBarButton
        
        let progressSpinner = UIActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        progressSpinner.color = UIColor.white
        progressSpinner.startAnimating()
        
        progressBarButton = UIBarButtonItem.init(customView: progressSpinner)
        progressBarButton.tintColor = .white
        
        
    }
    
    @objc func userDidTapX() {
        print("Back pressed")
        drawerShouldShow(postAd: false, coordinate: nil)
    }
    
    @objc func userDidTapPost() {
        
        print("Post pressed")

        if let coordinate = currentCoordinate {
            
            if let postAdVC = myPostAdViewController {
                if !postAdVC.validateData() {
                    print("Data invalid")
                    return
                }
                
                navigationItem.rightBarButtonItem = progressBarButton
                
                let body : [String: Any] = [
                    "lat": coordinate.latitude,
                    "long": coordinate.longitude,
                    "title": postAdVC.titleTextField.text ?? "",
                    "description": postAdVC.descriptionTextField.text ?? "",
                    "request_or_offer": postAdVC.discoveryType == .offer ? "offer" : "request",
                    "price": Int(postAdVC.priceTextField.text ?? "0") ?? 0
                ]
                
                APIManager.sharedInstance.postDiscovery(body: body, onSuccess: { (json) in
                    print("Successfully dropped a pin")
                    print(json)
                    
                    let dispatchGroup = DispatchGroup()
                    
                    let images = postAdVC.selectedAssets
                    
                    for (index, image) in images.enumerated() {
                        
                        dispatchGroup.enter()
                        
                        if let url = json["image_\(index)"].string {
                            print("image \(index) url")
                            print(url)
                            
                            APIManager.sharedInstance.putImage(url: url, image: image.fullResolutionImage!, onSuccess: { json in
                                print("success uploading image")
                                dispatchGroup.leave()
                            }, onFailure: { (err) in
                                print(err)
                                print("error uploding image")
                                dispatchGroup.leave()
                            })
                        }
                        
                        dispatchGroup.notify(queue: DispatchQueue.global(qos: .background)) {
                            
                            DispatchQueue.main.async {
                                self.navigationItem.rightBarButtonItem = self.postBarButton
                                // everything is done, just close and show a success message?
                                self.userDidTapX()
                            }
                            
                        }
                        
                        
                    }
                    
                    
                }) { (err) in
                    print("Error")
                    print(err)
                    self.navigationItem.rightBarButtonItem = self.postBarButton
                }
                
            }
            

        }
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
  
        let topPadding = self.statusBarHeight + 15.0
        
        
        searchBar = SearchView.init(frame: CGRect.init(x: 0.0 , y: topPadding, width: self.view.frame.size.width, height: 40.0), daddyVC: self)
        
        // Setting the search bar's frame to be used by the search
        // view controller
        Constants.searchBarFrame = searchBar.frame
        
        self.view.addSubview(searchBar)
//        searchBar.translatesAutoresizingMaskIntoConstraints
        
        
        
        // The small shrug when you pull the drawer all the way to the top is 20.0 points, so 15 allows u to keep it just below the
        self.topInset = topPadding + searchBar.frame.size.height - 15.0
        
        self.backgroundDimmingColor = UIColor.white
        self.backgroundDimmingOpacity = 1.0
    }
    

    var isShowingPostMenu = false
    
    // This method is called when someone long presses on the main map
    func didLongPressOnMap(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        print("Master VC knows about long press")
        
        if isShowingPostMenu {
            // dont do anything, just jot down the new coordinate, thats it.
            
        } else {
            drawerShouldShow(postAd: true, coordinate: coordinate)
        }
        
    }


    var topBlurView: UIView! = nil
    var viewArray = [UIView]()
    
    var currentCoordinate: CLLocationCoordinate2D?
    
    func drawerShouldShow(postAd: Bool, coordinate: CLLocationCoordinate2D?) {
        
        currentCoordinate = coordinate
        
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
                
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                
                self.topBlurView = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.topbarHeight + 50.0))
                let gradient = CAGradientLayer()
                gradient.frame = self.topBlurView.bounds
                gradient.colors = [UIColor.black.withAlphaComponent(0.8).cgColor, UIColor.clear.cgColor]
                self.self.topBlurView.layer.insertSublayer(gradient, at: 0)
                
                self.viewArray.append(self.topBlurView)
                self.myMapViewController?.view.addSubview(self.topBlurView)
                
                
                if let postAdDrawer = self.myPostAdViewController {
                    self.setDrawerPosition(position: .partiallyRevealed, animated: false)
                    self.setDrawerContentViewController(controller: postAdDrawer)
                    
                } else {
                    fatalError("My post drawer is empty, this should never happen")
                }
            }
            
        }
        
        // The user just backed out of posting an ad OR they actually did post the ad.
        else {
            
            // We are not showing the posting menu, we are shoing the discoveries instead.
            isShowingPostMenu = false
            
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            
//            self.drawerCornerRadius = 0.0
            self.backgroundDimmingColor = UIColor.white
            self.backgroundDimmingOpacity = 1.0
            
            for i in viewArray {
                i.removeFromSuperview()
            }
            
            viewArray.removeAll()
            
            
            
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
                mapVC.setupPins()
            }
            
            // If you press the back button, you just get rid of all the info that was saved.
            myPostAdViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SlavePostAdViewController") as? SlavePostAdViewController
            
            
        }
        
    }
    
    
    override func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat) {
        super.drawerPositionDidChange(drawer: drawer, bottomSafeArea: bottomSafeArea)
        
        print("Changed position of drawer")
    }

    
    func didSelectMarker(pin: Discovery) {
    }

}
