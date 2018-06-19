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

protocol SlaveMapViewControllerDelegate {
    func didLongPressOnMap(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D)
}

class SlaveMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    let locationManager = CLLocationManager()
    var userLocationCameraPosition: GMSCameraPosition? = nil
    
    var homeMapView: GMSMapView!
    
    var delegate: SlaveMapViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        
        
        checkLocationServices()
        setupMap()
        //setupSearchBar()
        
        
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
            
//            print(userLocationLat)
//            print(userLocationLong)
//
//            print("\n")
//
//            print(currentLocationLat)
//            print(currentLocationLong)
            
            if currentLocationLat == userLocationLat && currentLocationLong == userLocationLong  {
                mapView.settings.myLocationButton = false
            } else {
                mapView.settings.myLocationButton = true
            }
            
        }
    }
    
    // Function used by our master view controller
    func dropAPin() {
        self.mapView(homeMapView, didLongPressAt: (locationManager.location?.coordinate)!)
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
        
        // If we are posting an ad, send the screen all the way to the top. Otherwise just follow the drawer.
        if (drawer.drawerContentViewController as? SlavePostAdViewController) != nil {
            homeMapView.padding = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: (UIScreen.main.bounds.size.height * (2/3)) - bottomSafeArea, right: 0.0)
            
        } else {
            // This allows us to keep the google logo and the location button at the top
            // of the drawer at all times
            if distance <= 268.0 + bottomSafeArea
            {
                homeMapView.padding = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: distance - bottomSafeArea, right: 0.0)
            }
            else
            {
                homeMapView.padding = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 268.0, right: 0.0)
            }
        }
        
    }
    
}
