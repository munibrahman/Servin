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

protocol SlaveMapViewControllerDelegate {
    func didLongPressOnMap(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D)
    func didSelectMarker(pin: Pin)
}

class SlaveMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    

    let locationManager = CLLocationManager()
    var userLocationCameraPosition: GMSCameraPosition? = nil
    
    var homeMapView: GMSMapView!
    
    var delegate: SlaveMapViewControllerDelegate?
    var mapDelegate: SlaveMapViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        checkLocationServices()
        setupMap()
        setupPins()
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
    
    func setupPins() {
        let data = ServinData.allPins
        
        for pin in data {
            
            if let location = pin._location {
                let marker = GMSMarker(position: location)
                
                marker.map = homeMapView
            }
            
        }
        
        let urlString = "https://9z2epuh1wa.execute-api.us-east-1.amazonaws.com/dev/dummy"
        
        
        
        Alamofire.request(urlString, method: .get, parameters: ["minLat":"50.906684", "minLong":"-114.227922", "maxLat" : "51.174889", "maxLong" : "-113.908390"], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            //print(response.request)
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    //print(response.result.value)
                    
                    let json = JSON.init(response.result.value)
                    
                    print(json)
                    
                    for item in json["discoveries"].arrayValue {
                        print(item)
                        
                        let marker = GMSMarker.init()
                        
                        var first = true
                        for double in item["coordinates"].arrayValue {
                            print(Double(double.stringValue))
                            
                            if first {
                                marker.position.latitude = Double(double.stringValue) ?? 0.0
                            } else {
                                marker.position.longitude = Double(double.stringValue) ?? 0.0
                            }
                            
                            first = false
                        }
                        
                        print(marker.position)
                        marker.map = self.homeMapView
                        
                        
                    }
                    
                }
                
                break
                
            case .failure(_):
                print(response.result.error)
                break
                
            }
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
            } else {
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
