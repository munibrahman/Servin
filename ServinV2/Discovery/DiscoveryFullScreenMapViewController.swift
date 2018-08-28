//
//  DiscoveryFullScreenMapViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-06-17.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON

// This view controller contains a GMSMapView that spawns the view's entire frame.
// User is able to view their location in relation to the location of the pin.
class DiscoveryFullScreenMapViewController: UIViewController {

    var destination: CLLocationCoordinate2D? = nil
    var source: CLLocationCoordinate2D? = nil
    
    var gmsMap = GMSMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()

        // Do any additional setup after loading the view.
        
        gmsMap = GMSMapView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                gmsMap.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        destination = CLLocationCoordinate2D(latitude: 51.075477, longitude:  -114.137113)
        
        if let dest = destination {
            
            let marker = GMSMarker(position: dest)
            marker.map = gmsMap
            
            let camera = GMSCameraPosition.camera(withLatitude: dest.latitude, longitude: dest.longitude, zoom: 15)
            
            
            gmsMap.animate(to: camera)
            
            source = CLLocationCoordinate2D.init(latitude: 51.043992, longitude: -114.097551)
            if let actualLoc = source {
                drawPath(currentLocation: actualLoc, destinationLoc: dest)
            }
        }
        
        
        self.view.addSubview(gmsMap)
    }

    func setupNavigation() {
        
        if self.navigationController == nil {
            fatalError("DiscoverFullScreenMapViewController must be presented within a UINavigationViewController")
        }
        
        self.navigationController?.navigationBar.transparentNavigationBar()
        
        let backButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_grey"), style: .plain, target: self, action: #selector(backTapped))
        backButton.tintColor = .black
        
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backTapped() {
        print("Back tapped")
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drawPath(currentLocation: CLLocationCoordinate2D, destinationLoc: CLLocationCoordinate2D)
    {
        let origin = "\(currentLocation.latitude),\(currentLocation.longitude)"
        let destination = "\(destinationLoc.latitude),\(destinationLoc.longitude)"
        
        
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(Constants.googleMapsDirectionKey)"
        
        Alamofire.request(url).responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            let json = try! JSON(data: response.data!)
            print(json)
            let routes = json["routes"].arrayValue
            
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 3.0
                polyline.strokeColor = UIColor.greyBackgroundColor.withAlphaComponent(0.5)
                
                polyline.map = self.gmsMap
                
                self.gmsMap.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: polyline.path!), withPadding: 50))
                
                self.gmsMap.isMyLocationEnabled = true
            }
        }
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
