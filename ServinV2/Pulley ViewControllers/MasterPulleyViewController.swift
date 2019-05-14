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
import AWSPinpoint
import AWSAppSync
import AWSS3

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
    
    let progressView: UIProgressView = {
        let progressBar = UIProgressView.init(progressViewStyle: UIProgressView.Style.bar)
        progressBar.progressTintColor = UIColor.white
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        return progressBar
    }()
    
    var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
    var progressBlock: AWSS3TransferUtilityProgressBlock?
    
    let transferUtility = AWSS3TransferUtility.default()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupSideMenu()
        setupNavigationBar()
        
        if let myDelegate = UIApplication.shared.delegate as? AppDelegate {
            print("Asking to register for push notifications")
            myDelegate.registerForPushNotifications()
            
            
            if let targetingClient = myDelegate.pinpoint?.targetingClient {
                let endpoint = targetingClient.currentEndpointProfile()
                
                // Create a user and set its userId property
                let user = AWSPinpointEndpointProfileUser()
                user.userId = DefaultsWrapper.getString(Key.userName)
                // Assign the user to the endpoint
                endpoint.user = user
                endpoint.optOut = "NONE"
                print("Channel type: \(endpoint.channelType)")
                // Update the endpoint with the targeting client
                
                targetingClient.update(endpoint).continueWith { (task) -> Any? in
                    if let err = task.error {
                        print("Error no \(err)");
                    } else {
                        print("Success yes \(task.result)")
                        print("Assigned user ID \(user.userId ?? "nil") to endpoint \(endpoint.endpointId)")
                    }
                    
                    print("Ran something")
                    
                    return nil
                }
                

                
            }
        }
        // Do any additional setup after loading the view.
        
        
        view.addSubview(progressView)
        
        progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        progressView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
        
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
        self.drawerTopInset = topPadding + searchBar.frame.size.height - 15.0
        
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
