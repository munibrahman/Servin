//
//  ViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-04-14.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import GoogleMaps
import SideMenu

class ViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    let locationManager = CLLocationManager()
    var userLocationCameraPosition: GMSCameraPosition? = nil
    
    var homeMapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        
        
        checkLocationServices()
        setupMap()
        setupSideMenu()
        //setupSearchBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupSearchBar()
    }
    
    func setupSearchBar() {
        
        
        var topPadding: CGFloat = 10.0
        let sidepadding = topPadding
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            topPadding = topPadding + (window?.safeAreaInsets.top ?? 0.0)
            
        }
        
        let searchBar = SearchView.init(frame: CGRect.init(x: sidepadding , y: topPadding + 20.0, width: self.view.frame.size.width - (sidepadding * 2), height: 50.0), daddyVC: self)
        
        self.view.addSubview(searchBar)
        
    }
    func setupSideMenu() {
        
        let sideMenuTableVC = storyboard!.instantiateViewController(withIdentifier: "SideMenuTableViewController") as! SideMenuTableViewController
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
        
        SideMenuManager.default.menuWidth = view.frame.width * CGFloat(0.8)
        
    }
    
    
    func setupMap() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        homeMapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                homeMapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        homeMapView.frame = CGRect.init(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height )
        self.view.addSubview(homeMapView)

        homeMapView.delegate = self
    
        self.homeMapView.settings.rotateGestures = false
        self.homeMapView.settings.tiltGestures = false
        
        homeMapView.isMyLocationEnabled = true
        homeMapView.isUserInteractionEnabled = true

    }

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        
        if (userLocationCameraPosition != nil) {
            //print("moved location")
            let userLocationLat = userLocationCameraPosition!.target.latitude.truncate(places: 3)
            let userLocationLong = userLocationCameraPosition!.target.longitude.truncate(places: 3)
            
            let currentLocationLat = position.target.latitude.truncate(places: 3)
            let currentLocationLong = position.target.longitude.truncate(places: 3)
            
            print(userLocationLat)
            print(userLocationLong)
            
            print("\n")
            
            print(currentLocationLat)
            print(currentLocationLong)
            
            if currentLocationLat == userLocationLat && currentLocationLong == userLocationLong  {
                mapView.settings.myLocationButton = false
            } else {
                mapView.settings.myLocationButton = true
            }
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkLocationServices() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            
            print("location granted")
            break
        // ...
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            let alertController = UIAlertController(
                title: "Location Access is disabled",
                message: "In order to view discoveries near you, please open this app's settings and set location access to 'While Using the App'.",
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                }
            }
            alertController.addAction(openAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 15.0)
        
        self.userLocationCameraPosition = camera
        self.homeMapView.animate(to: camera)
        self.homeMapView.settings.myLocationButton = true
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
    }

}

