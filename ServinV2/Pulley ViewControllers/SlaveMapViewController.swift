//
//  SlaveMapViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-04-14.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import GoogleMaps
import Pulley
import Alamofire
import SwiftyJSON
import AlamofireImage
import AWSAppSync

protocol SlaveMapViewControllerDelegate {
    func didLongPressOnMap(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D)
    func didSelectMarker(pin: Discovery)
}

class SlaveMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    

    let locationManager = CLLocationManager()
    var userLocationCameraPosition: GMSCameraPosition? = nil
    
    var homeMapView: GMSMapView!
    
    var delegate: SlaveMapViewControllerDelegate?
    var mapDelegate: SlaveMapViewControllerDelegate?
    
    
    var inviteButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupPins()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        let inviteButtonHeight: CGFloat = 40.0
        let inviteButtonWidth: CGFloat = 110.0
        
        inviteButton = UIButton.init(frame: CGRect.init(x: self.view.frame.size.width - inviteButtonWidth - 5, y: self.view.frame.size.height - inviteButtonHeight - 5, width: inviteButtonWidth, height: inviteButtonHeight))
        
        inviteButton.backgroundColor = .white
        inviteButton.layer.cornerRadius = inviteButtonHeight / 2
        inviteButton.clipsToBounds = true
        inviteButton.layer.borderColor = UIColor.blackFontColor.withAlphaComponent(0.2).cgColor
        inviteButton.layer.borderWidth = 1.0
        
        inviteButton.addTarget(self, action: #selector(didTapInviteFriends), for: .touchUpInside)
        
        
        let inviteLabel = UILabel.init()
        inviteLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        inviteLabel.textColor = UIColor.blackFontColor
        inviteLabel.text = "Invite Friends!"
        
        inviteButton.addSubview(inviteLabel)
        
        inviteLabel.translatesAutoresizingMaskIntoConstraints = false
        
        inviteLabel.centerXAnchor.constraint(equalTo: inviteButton.centerXAnchor).isActive = true
        inviteLabel.centerYAnchor.constraint(equalTo: inviteButton.centerYAnchor).isActive = true
        
        
        checkLocationServices()
        setupMap()
        setupPins()
    }
    
    @objc func didTapInviteFriends() {
        
        if let parent = self.parent as? MasterPulleyViewController {
            print("Yeah my parent is the master pulley")
            
            UIApplication.topViewController()?.present(UINavigationController.init(rootViewController: InviteOthersViewController()), animated: true, completion: nil)
        }
        
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
        
        self.view.insertSubview(inviteButton, aboveSubview: homeMapView)

    }
    
    func setupPins() {
//        let data = ServinData.allPins
//
//        for pin in data {
//
//            if let location = pin._location {
//                let marker = GMSMarker(position: location)
//
//                marker.map = homeMapView
//            }
//
//        }
        
        if userLocationCameraPosition != nil {
        
            let projection = homeMapView.projection.visibleRegion()
            
            let topRightCorner: CLLocationCoordinate2D = projection.farRight
            let bottomLeftCorner: CLLocationCoordinate2D = projection.nearLeft
            
//            let marker = GMSMarker.init()
//            marker.position = topRightCorner
//
//            let marker2 = GMSMarker.init(position: bottomLeftCorner)
//
//            marker.map = self.homeMapView
//            marker2.map = self.homeMapView
            
            print(topRightCorner)
            print(bottomLeftCorner)
            
            let params: Parameters = [
                "latMin" : bottomLeftCorner.latitude,
                "latMax" : topRightCorner.latitude,
                "longMin" : bottomLeftCorner.longitude,
                "longMax" : topRightCorner.longitude
            ]
            
            print("Parameters are \(params)")
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let appSyncClient = appDelegate.appSyncClient
                
                let discoveriesAroundMe = GetSurroundingDiscoveriesQuery.init(latMin: bottomLeftCorner.latitude,
                                                                              latMax: topRightCorner.latitude,
                                                                              longMin: bottomLeftCorner.longitude,
                                                                              longMax: topRightCorner.longitude)
                
                
                appSyncClient?.fetch(query: discoveriesAroundMe, cachePolicy: CachePolicy.returnCacheDataAndFetch, resultHandler: { (result, error) in
                    if let error = error, let errors = result?.errors {
                        print(error)
                        print(errors)
                        self.showErrorNotification(title: "Error", subtitle: "Can't pull discoveries right now, retrying.")
                    }
                    
                    if let result = result {
                        print("Successfully pulled discoveries")
//                        print(result)
                        
                        if let discoveries = result.data?.getSurroundingDiscoveries, let parentVC = self.parent as? MasterPulleyViewController {
                            
                            print("Super is master pulley view controller")
                            parentVC.myDiscoveriesViewController?.discoveriesAroundMe = discoveries
                            parentVC.myDiscoveriesViewController?.pinsNearbyCollectionView.reloadData()
                            // parentVC is someViewController
                            
                            
                            
                            for discovery in discoveries {
//                                print("discovery \(discovery)")
                                if let latitude = discovery?.latitude, let longitude = discovery?.longitude {
                                    let marker = GMSMarker(position: CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude))
                    
                                    print("got lat long")
                                    print(latitude)
                                    print(longitude)
                                    DispatchQueue.main.async {
                                        marker.map = self.homeMapView
                                    }
                                    
                                }
                            }
                        }
                        
                        
                        
                    }
                    
                })
                
            }
            
        }
        
        
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture {
            print("Moving because of gesture")
            self.setupPins()
        }
    }
    

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        if (userLocationCameraPosition != nil) {
            //print("moved location")
            let userLocationLat = userLocationCameraPosition!.target.latitude.truncate(places: 3)
            let userLocationLong = userLocationCameraPosition!.target.longitude.truncate(places: 3)
            
            let currentLocationLat = position.target.latitude.truncate(places: 3)
            let currentLocationLong = position.target.longitude.truncate(places: 3)
            
            if currentLocationLat == userLocationLat && currentLocationLong == userLocationLong  {
                mapView.settings.myLocationButton = false
                inviteButton.isEnabled = true
                inviteButton.isHidden = false
                
            } else {
                
                inviteButton.isHidden = true
                inviteButton.isEnabled = false
                
                mapView.settings.myLocationButton = true
            }
            
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("did tap marker")
        
        let location = marker.position
        
        let data = ServinData.allPins
        
        let pin = data.filter { (pin) -> Bool in
            if let loc = pin._location {
                if loc.latitude == location.latitude && loc.longitude == loc.longitude {
                    return true
                }
            }
            
            return false
        }
        
        if let specificPin = pin.first {
            mapDelegate?.didSelectMarker(pin: specificPin)
        }
        
        return false
    }
    
    // Function used by our master view controller
    func dropAPin() {
        
        
        if let location = locationManager.location {
            self.mapView(homeMapView, didLongPressAt: location.coordinate)
        } else {
            print("Location is nil right now...")
        }
        
    }
    
    // Delegate function
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        print("long pressed, drop a pin!")
        delegate?.didLongPressOnMap(mapView, didLongPressAt: coordinate)
        
        mapView.clear()
        
        
        let marker = GMSMarker(position: coordinate)
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15.0)
        
        mapView.animate(to: camera)
        marker.map = mapView
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkLocationServices() {
        
        print("Cheking location services")
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            
            print("Location granted")
            break
        // ...
        case .notDetermined:
            print("Location not determined")
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            print("Location restricted or denied")
            let alertController = UIAlertController(
                title: "Location Access is disabled",
                message: "In order to view discoveries near you, please open this app's settings and set location access to 'While Using the App'.",
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = NSURL(string:UIApplication.openSettingsURLString) {
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
        
        // Call this after user's location has been updated.
        self.setupPins()
    }

}


// Delegate methods for Pulley
extension SlaveMapViewController: PulleyPrimaryContentControllerDelegate {
    // When the drawer reaches all the way to the top, it eliminates the shadow in the background
    func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat) {
        //print(drawer.drawerPosition)
        if drawer.drawerPosition == PulleyPosition.open {
            drawer.shadowRadius = 0.0
            drawer.shadowOpacity = 0.0
        } else {
            drawer.shadowRadius = 3.0
            drawer.shadowOpacity = 0.1
        }
    }
    


    
    func drawerChangedDistanceFromBottom(drawer: PulleyViewController, distance: CGFloat, bottomSafeArea: CGFloat)
    {
        
        let xPosition = inviteButton.frame.origin.x
        
        //View will slide 20px up
        var yPosition = inviteButton.frame.origin.y
        
        let height = inviteButton.frame.size.height
        let width = inviteButton.frame.size.width
        
        // If we are posting an ad, send the screen all the way to the top. Otherwise just follow the drawer.
        if (drawer.drawerContentViewController as? SlavePostAdViewController) != nil {
            homeMapView.padding = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: (UIScreen.main.bounds.size.height * (2/3)) - bottomSafeArea, right: 0.0)
            
//            print("1 here")
            yPosition = yPosition - bottomSafeArea
            
            self.inviteButton.frame = CGRect.init(x: xPosition, y: yPosition, width: width, height: height)
            
            
        } else {
            // This allows us to keep the google logo and the location button at the top
            // of the drawer at all times
            if distance <= 268.0 + bottomSafeArea
            {
                
//                print("2 here")
                homeMapView.padding = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: distance - bottomSafeArea, right: 0.0)
                
                yPosition = (self.view.frame.size.height) - (distance + height + 10.0)
                
                self.inviteButton.frame = CGRect.init(x: xPosition, y: yPosition, width: width, height: height)
                
            }
            else
            {
                
//                print("3 here")
                homeMapView.padding = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 268.0, right: 0.0)
                
                yPosition = (self.view.frame.size.height) - (268.0 + bottomSafeArea + height + 10.0)
                
                self.inviteButton.frame = CGRect.init(x: xPosition, y: yPosition, width: width, height: height)
                
            }
        }
        
    }
    
}
