//
//  MasterPulleyViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-21.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

// This view controller is the actual PulleyVC, the search bar will rest on this view controller.
// Possible scenarios for this view controller
// Normal: Shows the menu icon, search bar, map shows pins nearby and the drawerVC is SlaveDiscoveries view controller
// Posting: Hides menu icon, search bar. Shows the navigationbar with embedded post and exit buttons. DrawerVC is slavepostad view controller
// Search: Changes menu icon to the < icon, displays a cover over the map and drawer VC, shows search results table view controller.
// SearchResults: Menu icon is still < icon, search bar still has the searched text, only displays the discoveries of the searched term.


import UIKit
import Pulley
import GoogleMaps
import SideMenu
import AWSPinpoint
import AWSAppSync
import AWSS3
import AwesomeSpotlightView

class MasterPulleyViewController: PulleyViewController, SlaveMapViewControllerDelegate {
    
    var myMapViewController: SlaveMapViewController?
    var myDiscoveriesViewController: SlaveDiscoveriesViewController?
    var myPostAdViewController: SlavePostAdViewController?
    
    var mySearchResultsViewController: SlaveSearchResultsViewController?
    
    var postBarButton: UIBarButtonItem!
    var progressBarButton: UIBarButtonItem!
    
    enum MasterViewControllerStates {
        case normal // Shows discoveries on the map and recommendations
        case posting // Posting a discovery
        case searching // Actually searching for something, shows the searh bar and the tableview for search results
        case searchResults // Shows the results of the search on the map
    }
    
    let progressView: UIProgressView = {
        let progressBar = UIProgressView.init(progressViewStyle: UIProgressView.Style.bar)
        progressBar.progressTintColor = UIColor.white
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        return progressBar
    }()
    
    var currentState: MasterViewControllerStates = .normal
    
    var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
    var progressBlock: AWSS3TransferUtilityProgressBlock?
    
    let transferUtility = AWSS3TransferUtility.default()
    
    var searchBackgroundView: UIView = {
        let view = UIView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    static let tableViewCellId = "TableViewCell"
    
    var spotlightView = AwesomeSpotlightView()
    
    // This array keeps track of all the previous searches
    var historyData = [String]()
    
    var filteredData: [String?]?
    
    lazy var searchBar: HomeMapSearchBar = {
        let bar = HomeMapSearchBar.init()
        bar.delegate = self
        bar.barStyle = .default
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    lazy var searchResultsTableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.keyboardDismissMode = .onDrag
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchViewController.tableViewCellId)
        return tableView
    }()
    
    
    var menuButton: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.system)
        button.setImage(#imageLiteral(resourceName: "menu_icon"), for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.blackFontColor, for: UIControl.State.normal)
        button.tintColor = UIColor.blackFontColor
        return button
    }()
    
    // Used to display serch results on the map
    var searchedDiscoveries = [DiscoveryQuery.Data.Discovery]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let storedData = DefaultsWrapper.getArray(key: Key.searchHistory, defaultValue: []) as? [String] {
            historyData = storedData
        }
        
        filteredData = historyData
        
        setupViews()
        setupSideMenu()
        setupNavigationBar()
        
        PinpointManager.shared.subscribeToPinpointNotifications()
        // Do any additional setup after loading the view.
        
        
        view.addSubview(progressView)
        
        progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        progressView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
        
    }
    
    
    
    func changeState(to: MasterViewControllerStates) {
        currentState = to
        switch to {
        case .normal:
            // TODO: Change menu icon to three bars
            // Hide background view of search
            // Hide search results table view controller
            print("Change to normal state")
            if let slaveDiscoveriesVC = myDiscoveriesViewController {
                UIView.transition(with: searchBackgroundView, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                    self.menuButton.setImage(#imageLiteral(resourceName: "menu_icon"), for: UIControl.State.normal)
                    self.searchBar.endEditing(true)
                    self.searchBar.text = nil
                    self.searchBackgroundView.isHidden = true
                })
                self.setDrawerContentViewController(controller: slaveDiscoveriesVC, animated: true)
                self.myMapViewController?.showMapDiscoveries()
            }
        case .posting:
            print("Change state to posting")
        // TODO: Hide the menu button and hide the search bar
        case .searching:
            print("Show search related UI")
            print("Showing search")
            menuButton.setImage(#imageLiteral(resourceName: "<_black"), for: UIControl.State.normal)
            UIView.transition(with: searchBackgroundView, duration: 0.2, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                self.searchBackgroundView.isHidden = false
            })
            
        case .searchResults:
            print("Show search results, hide the background view and resign the keyboard responder ")
            
            if let searchResultsDrawer = mySearchResultsViewController {
                searchResultsDrawer.discoveriesAroundMe = searchedDiscoveries
                self.searchBar.endEditing(true) // End editing to kill off the responder and hide keyboard
                self.searchBackgroundView.isHidden = true // Hide the background view
                self.setDrawerContentViewController(controller: searchResultsDrawer, animated: true)
                self.myMapViewController?.currentState = SlaveMapViewController.State.search
            }
            
        }
    }
    
    
    func setupViews() {
    
        view.addSubview(searchBackgroundView)
        searchBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        searchBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        searchBackgroundView.isHidden = true
        
        // Copied from search controller.
        view.addSubview(menuButton)
        menuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        menuButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 25).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        menuButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // TODO: Show normal view with all the surrounding discoveries.
        menuButton.addTarget(self, action: #selector(didTapMenuButton), for: UIControl.Event.touchUpInside)
        
        
        view.addSubview(searchBar)
        searchBar.leadingAnchor.constraint(equalTo: menuButton.trailingAnchor, constant: 20).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 15).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Table view to show search results
        searchBackgroundView.addSubview(searchResultsTableView)
        searchResultsTableView.leadingAnchor.constraint(equalTo: searchBackgroundView.leadingAnchor, constant: 8).isActive = true
        searchResultsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8).isActive = true
        searchResultsTableView.trailingAnchor.constraint(equalTo: searchBackgroundView.trailingAnchor, constant: -8).isActive = true
        searchResultsTableView.bottomAnchor.constraint(equalTo: searchBackgroundView.layoutMarginsGuide.bottomAnchor, constant: -8).isActive = true
        
        let topPadding = self.statusBarHeight + 15.0
        
        // Variable used by the drawer VC
        // The small shrug when you pull the drawer all the way to the top is 20.0 points, so 15 allows u to keep it just below the
        self.drawerTopInset = topPadding + 40.0 - 15.0
        
        self.backgroundDimmingColor = UIColor.white
        self.backgroundDimmingOpacity = 1.0
    }
    
    @objc func didTapMenuButton() {
        print("Menu button has been tapped, do appripriate action")
        switch currentState {
        case .normal:
            // This is the normal state, so the menu button is visible. Display the side menu to the user.
            if let menuController = SideMenuManager.default.menuLeftNavigationController {
                self.present(menuController, animated: true, completion: nil)
            }
            
        case .posting:
            print("In the middle of posting a discovery. Why am I visible? I should be hidden!")
        case .searching:
            print("In the middle of searching, I should be displaying the < arrow right now. Since I have been tapped, take user back to normal screen" )
            self.changeState(to: MasterPulleyViewController.MasterViewControllerStates.normal)
        case .searchResults:
            print("In the middle of showing search results. Should be showing the < icon. I have been tapped go to showing normal discoveries" )
            self.changeState(to: MasterPulleyViewController.MasterViewControllerStates.normal)
        }
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
    
    
    func setupSpotlight() {
//        let logoImageViewSpotlightRect = CGRect(x: logoImageView.frame.origin.x, y: logoImageView.frame.origin.y, width: logoImageView.frame.size.width, height: logoImageView.frame.size.height)
//        let logoImageViewSpotlightMargin = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
//        let logoImageViewSpotlight = AwesomeSpotlight(withRect: logoImageViewSpotlightRect, shape: .circle, text: "logoImageViewSpotlight", margin: logoImageViewSpotlightMargin)
        
        let menuImageViewSpotlightRect = CGRect.init(x: menuButton.frame.origin.x,
                                                     y: menuButton.frame.origin.y,
                                                     width: menuButton.frame.size.width,
                                                     height: menuButton.frame.size.height)
        
        
        let menuImageViewSpotlight = AwesomeSpotlight.init(withRect: menuImageViewSpotlightRect,
                                                           shape: AwesomeSpotlight.AwesomeSpotlightShape.circle, text:  "You can open the menu by tapping on here!", margin: UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10), isAllowPassTouchesThroughSpotlight: false)
        
        
        
        let drawerSpotlightRect = CGRect.init(x: 0,
                                              y: view.frame.size.height - drawerDistanceFromBottom.distance,
                                              width: view.frame.size.width,
                                              height: drawerDistanceFromBottom.distance)
        
        
        let drawerSpotlight = AwesomeSpotlight.init(withRect: drawerSpotlightRect,
                                                           shape: AwesomeSpotlight.AwesomeSpotlightShape.roundRectangle, text:  "Welcome to Servin!\nThis is where all your surrounding pins will be shown!", margin: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0), isAllowPassTouchesThroughSpotlight: false)
        
        let postAdSpotlightRect = CGRect.init(x: 0,
                                              y: 0,
                                              width: view.frame.size.width,
                                              height: view.frame.size.height - drawerDistanceFromBottom.distance)
        
        let postAdSpotlight = AwesomeSpotlight.init(withRect: postAdSpotlightRect,
                                                    shape: AwesomeSpotlight.AwesomeSpotlightShape.roundRectangle, text:  "Press and hold on the map to offer or request services!", margin: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0), isAllowPassTouchesThroughSpotlight: true)
        
//        let nameLabelSpotlight = AwesomeSpotlight(withRect: nameLabel.frame, shape: .rectangle, text: "nameLabelSpotlight")
//
//        let showButtonSpotSpotlight = AwesomeSpotlight(withRect: showButton.frame, shape: .roundRectangle, text: "showButtonSpotSpotlight")
//
//        let showWithContinueAndSkipButtonSpotlight = AwesomeSpotlight(withRect: showWithContinueAndSkipButton.frame, shape: .roundRectangle, text: "showWithContinueAndSkipButtonSpotlight")
//
//        let showAllAtOnceButtonSpotlight = AwesomeSpotlight(withRect: showAllAtOnceButton.frame, shape: .roundRectangle, text: "showAllAtOnceButtonSpotlight", isAllowPassTouchesThroughSpotlight: true)
//
//        spotlightView = AwesomeSpotlightView(frame: view.frame, spotlight: [logoImageViewSpotlight, nameLabelSpotlight, showButtonSpotSpotlight, showWithContinueAndSkipButtonSpotlight, showAllAtOnceButtonSpotlight])
        spotlightView = AwesomeSpotlightView(frame: view.frame, spotlight: [ drawerSpotlight, menuImageViewSpotlight, postAdSpotlight])
        spotlightView.cutoutRadius = 8
        spotlightView.delegate = self
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
                
                print("Discovery: \(body)")
                
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate  {
                    let appSyncClient = appDelegate.appSyncClient
                    
                    let postDiscoveryMutation = PostDiscoveryMutation.init(title: postAdVC.titleTextField.text ?? "",
                                                                           price: Int(postAdVC.priceTextField.text ?? "0") ?? 0,
                                                                           request_or_offer: postAdVC.discoveryType == .offer ? "offer" : "request",
                                                                           description: postAdVC.descriptionTextField.text ?? "",
                                                                           lat: coordinate.latitude,
                                                                           long: coordinate.longitude)
                    
                    appSyncClient?.perform(mutation: postDiscoveryMutation) { (result, error) in
                        if error != nil || result?.errors != nil {
                            print(error)
                            print(result?.errors)
                            self.showErrorNotification(title: "Error", subtitle: "Can't drop a pin right now, please try again")
                            DispatchQueue.main.async {
                                self.navigationItem.rightBarButtonItem = self.postBarButton
                            }
                        }
                        
                        
                        if let result = result {
                            print(result)
                            //                            DispatchQueue.main.async {
                            //                                self.navigationItem.rightBarButtonItem = self.postBarButton
                            //                                // everything is done, just close and show a success message?
                            //                                self.userDidTapX()
                            //                            }
                            
                            let dispatchGroup = DispatchGroup()
                            
                            let images = postAdVC.selectedAssets
                            
                            guard let discoveryId = result.data?.postDiscovery?.discoveryId, let geoHashPrefix = result.data?.postDiscovery?.geohashPrefix else {
                                print("Unable to post discovery")
                                DispatchQueue.main.async {
                                    self.navigationItem.rightBarButtonItem = self.postBarButton
                                }
                                return
                            }
                            
                            for (index, image) in images.enumerated() {
                                
                                if let imageData = image.fullResolutionImage?.jpegData(compressionQuality: 0.5) {
                                    
                                    dispatchGroup.enter()
                                    self.uploadImage(with: imageData,
                                                     key: "public/\(discoveryId)/image_\(index).jpg",
                                        discoveryId: discoveryId,
                                        geoHashPrefix: geoHashPrefix,
                                        index: index,
                                        onSuccess: {
                                            
                                            print("Success")
                                            dispatchGroup.leave()
                                    }, onError: { error in
                                        print(error)
                                        print("Error uploading the image")
                                        self.showErrorNotification(title: "Error", subtitle: "Unable to upload images, please try again")
                                        DispatchQueue.main.async {
                                            self.navigationItem.rightBarButtonItem = self.postBarButton
                                        }
                                        dispatchGroup.leave()
                                    })
                                    
                                }
                                
                                
                                
                                //                                if let url = json["image_\(index)"].string {
                                //                                    print("image \(index) url")
                                //                                    print(url)
                                //
                                //                                    APIManager.sharedInstance.putImage(url: url, image: image.fullResolutionImage!, onSuccess: { json in
                                //                                        print("success uploading image")
                                //                                        dispatchGroup.leave()
                                //                                    }, onFailure: { (err) in
                                //                                        print(err)
                                //                                        print("error uploding image")
                                //                                        dispatchGroup.leave()
                                //                                    })
                                //                                }
                                
                                dispatchGroup.notify(queue: DispatchQueue.global(qos: .background)) {
                                    
                                    DispatchQueue.main.async {
                                        self.navigationItem.rightBarButtonItem = self.postBarButton
                                        // everything is done, just close and show a success message?
                                        self.userDidTapX()
                                    }
                                    
                                }
                                
                                
                            }
                            
                            
                        }
                    }
                }
                
                
            }
            
            
        }
    }
    
    
    
    func uploadImage(with data: Data, key: String,
                     discoveryId: String,
                     geoHashPrefix: Int,
                     index: Int,
                     onSuccess: @escaping () -> Void, onError: @escaping (Error?) -> Void ) {
        
        print("Image Key \(key)")
        self.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                if (self.progressView.progress < Float(progress.fractionCompleted)) {
                    self.progressView.progress = Float(progress.fractionCompleted)
                }
            })
        }
        
        self.completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                self.progressView.progress = 0
                if let error = error {
                    print("Failed with error: \(error)")
                    //                    self.statusLabel.text = "Failed"
                    onError(error)
                }
                else{
                    //                    self.statusLabel.text = "Success"
                    print("Success! Make the call in here.")
                    onSuccess()
                }
            })
        }
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = progressBlock
        expression.setValue(discoveryId, forRequestParameter: "x-amz-meta-discovery_id")
        expression.setValue("\(geoHashPrefix)", forRequestParameter: "x-amz-meta-geohash_prefix")
        expression.setValue("\(index)", forRequestParameter: "x-amz-meta-image_number")
        
        DispatchQueue.main.async(execute: {
            //            self.statusLabel.text = ""
            self.progressView.progress = 0
        })
        
        
        transferUtility.uploadData(
            data,
            key: key,
            contentType: "image/jpeg",
            expression: expression,
            completionHandler: completionHandler).continueWith { (task) -> AnyObject? in
                if let error = task.error {
                    print(error)
                    print("Error: \(error.localizedDescription)")
                    onError(error)
                    DispatchQueue.main.async {
                        self.progressView.progress = 0
                        //                        self.statusLabel.text = "Failed"
                    }
                }
                
                if let _ = task.result {
                    
                    DispatchQueue.main.async {
                        //                        self.statusLabel.text = "Uploading..."
                        print("Upload Starting!")
                    }
                    
                    // Do something with uploadTask.
                }
                
                return nil;
        }
        
    }
    
    var isShownBefore = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isShownBefore {
            setDrawerPosition(position: .partiallyRevealed, animated: true)
            
            isShownBefore = true
            
            let shownWalkthrough = UserDefaults.standard.bool(forKey: "shownWalthrough")
            if shownWalkthrough  {
                print("Not first launch.")
            } else {
                print("First launch, show the walkthrough")
                UserDefaults.standard.set(true, forKey: "shownWalthrough")
                
                setupSpotlight()
                view.addSubview(spotlightView)
                spotlightView.continueButtonModel.isEnable = true
                spotlightView.skipButtonModel.isEnable = true
                spotlightView.showAllSpotlightsAtOnce = false
                spotlightView.start()
            }
            
            
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                self.menuButton.transform = top
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
                self.menuButton.transform = .identity
                
            }) { (completed) in
                
            }
            
            if let discoveriesVC = myDiscoveriesViewController {
                self.setDrawerContentViewController(controller: discoveriesVC)
            }
            
            // This clears the pin from the map
            if let mapVC = self.primaryContentViewController as? SlaveMapViewController {
                mapVC.homeMapView.clear()
                mapVC.showMapDiscoveries()
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

extension MasterPulleyViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    // This function fetches autocomplete results ONLY.
    // Everything else must be done seperately including the actual serach functionality
    func performAutoComplete(query: String?) {
        print("Text changed")
        
        let suggestionQuery = AutocompleteQuery.init(keyword: query)
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let appSyncClient = appDelegate.appSyncClient
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            appSyncClient?.fetch(query: suggestionQuery, cachePolicy: CachePolicy.fetchIgnoringCacheData, queue: DispatchQueue.global(qos: .background), resultHandler: { (results, error) in
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
                if let error = error {
                    print("Error fetching suggestions")
                    print(error)
                }
                
                if let errors = results?.errors {
                    print("Errors fetching suggestions")
                    print(errors)
                }
                
                if let result = results, let data = result.data, let autocomplete = data.autocomplete {
                    self.filteredData = autocomplete
                    
                    DispatchQueue.main.async {
                        self.searchResultsTableView.reloadData()
                        
                    }
                }
                
            })
            
        }
    }
    
    func performSearch(query: String?) {
        
        
        guard let query = query else {
            print("Query is empty, dont do anything")
            return
        }
        
        self.searchBar.text = query
        historyData.append(query)
        
        DefaultsWrapper.setArray(key: Key.searchHistory, value: historyData as NSArray)
        
        print("Data array is")
        print(historyData)
        
        let searchQuery = SearchQuery.init(keyword: query)
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let appSyncClient = appDelegate.appSyncClient
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            appSyncClient?.fetch(query: searchQuery, cachePolicy: CachePolicy.returnCacheDataAndFetch, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background), resultHandler: { (results, error) in
                if let error = error {
                    print("Error fetching search")
                    print(error)
                }
                
                if let errors = results?.errors {
                    print("Errors fetching search")
                    print(errors)
                }
                
                if let searchResults = results?.data?.search {
                    print("Got discovery array ")
                    
                    if searchResults.count == 0 {
                        print("No results for this query")
                        //TODO: Show an alert that nothing exists, and don't change anything
                        self.showAlertController(title: "No results", subtitle: nil)
                        return
                    }
                    
                    let myGroup = DispatchGroup.init()
                    
                    for result in searchResults {
                        
                        
                        
                        if let discoveryId = result?.discoveryId {
                            print("Discovery Id \(discoveryId)")
                            
                            myGroup.enter()
                            
                            let getDiscovery = DiscoveryQuery.init(discoveryId: discoveryId)
                            
                            appSyncClient?.fetch(query: getDiscovery, cachePolicy: CachePolicy.returnCacheDataElseFetch, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background), resultHandler: { (discoveryResults, error) in
                                if let error = error {
                                    print("Error fetching discovery from id")
                                    print(error)
                                }
                                
                                if let errors = discoveryResults?.errors {
                                    print("Errors fetching discovery from id")
                                    print(errors)
                                }
                                
                                
                                if let discovery = discoveryResults?.data?.discovery {
                                    self.searchedDiscoveries.append(discovery)
                                    
                                }
                                
                                
                                myGroup.leave()
                                
                            })
                            
                            
                            
                        }
                    }
                    
                    myGroup.notify(queue: DispatchQueue.main, execute: {
                        self.changeState(to: MasterPulleyViewController.MasterViewControllerStates.searchResults)
                        self.myMapViewController?.searchedDiscoveries = self.searchedDiscoveries
                    })
                    
                }
            })
            
        }
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("text changed")
        print(searchText)
        if searchText.isEmpty {
            print("Empty text")
            filteredData = historyData
            self.searchResultsTableView.reloadData()
        } else {
            self.performAutoComplete(query: searchText)
        }
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // TODO: Show search results controller
        // If no results, show an alert that mentions no results.
        
        // Otherwise, show the map with populated search results
        print("Search button pressed")
        self.performSearch(query: searchBar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel button clicked")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Searchbar did begin editing")
        // TODO: Show searching UI (Change menu button to back button, show a cover over the current VC and display the table view).
        self.changeState(to: MasterPulleyViewController.MasterViewControllerStates.searching)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("SearchBar did end editing")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewController.tableViewCellId, for: indexPath) as! SearchTableViewCell
        if let filtered = filteredData, let text = filtered[indexPath.row] {
            cell.label.text = text
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Did select row")
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let filtered = filteredData, let query = filtered[indexPath.row] {
            
            self.performSearch(query: query)
            
        }
    }
    
    
    func searchResultsToggle(show: Bool) {
        // Get the autocomplete query and run a search query to retrieve all the discoveries possible
        // Get those discoveries and show the results view, so show the pins on the map and also show another view controller in the drawer view controller.
    }
}


extension MasterPulleyViewController : AwesomeSpotlightViewDelegate {
    
    func spotlightView(_ spotlightView: AwesomeSpotlightView, willNavigateToIndex index: Int) {
        print("spotlightView willNavigateToIndex index = \(index)")
    }
    
    func spotlightView(_ spotlightView: AwesomeSpotlightView, didNavigateToIndex index: Int) {
        print("spotlightView didNavigateToIndex index = \(index)")
    }
    
    func spotlightViewWillCleanup(_ spotlightView: AwesomeSpotlightView, atIndex index: Int) {
        print("spotlightViewWillCleanup atIndex = \(index)")
    }
    
    func spotlightViewDidCleanup(_ spotlightView: AwesomeSpotlightView) {
        print("spotlightViewDidCleanup")
    }
    
}
