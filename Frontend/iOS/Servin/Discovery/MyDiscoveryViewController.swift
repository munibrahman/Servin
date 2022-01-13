//
//  MyDiscoveryViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-06-18.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON

// Discovery pin works best in this context
class MyDiscoveryViewController: UserDiscoveryViewController {
    
    var discovery:  GetMyDiscoveriesQuery.Data.GetMyDiscovery?
    var location: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.insertSubview(discoveryCollectionView, at: 100)

        // Do any additional setup after loading the view.
        
        self.imInterstedView.removeFromSuperview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        let backButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_grey"), style: .plain, target: self, action: #selector(self.userDidTapBack))
        
        
        
        let shareButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "share_icon"), style: .plain, target: self, action: #selector(self.userDidTapShare))
        
        let editButton = UIBarButtonItem.init(title: "Edit", style: .plain, target: self, action: #selector(self.userDidTapEdit))
        
        
        backButton.tintColor = .black
        shareButton.tintColor = .black
        editButton.tintColor = .black
        
        self.navigationItem.rightBarButtonItems = [editButton, shareButton]
        self.navigationItem.leftBarButtonItem = backButton
        
    }
    
    @objc func userDidTapEdit() {
        print("Edit this ad, im inside mydiscoveryviewcontroller")
        
        if let editVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String.init(describing: EditDiscoveryViewController.self)) as? EditDiscoveryViewController {
            
            editVC.discovery = discovery
            
            self.navigationController?.pushViewController(editVC, animated: true)
        }
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func userDidTapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: Map View
    
    override func setupMap() {
        gmsMap = GMSMapView.init(frame: self.view.bounds)
        gmsMap.isUserInteractionEnabled = false
        
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
        
        if let geoJson = discovery?.geoJson {
            let data = Data(geoJson.utf8)
//            print(geoJson)
//            print(data)

            
            do {
                let jsonObj = try JSON.init(data: data, options: JSONSerialization.ReadingOptions.allowFragments)
//                print("got json")
//                print(jsonObj)

                
                // I dont know why, but for some fucking stupid reason I need to first convert the string into json, then convert that json back into a string and then to json
                // Otherwise it wont work...
                
                if let rawJson = jsonObj.rawString() {
                    let actualdata = JSON.init(parseJSON: rawJson)
                    
                    let coordinateArray = actualdata["coordinates"].arrayValue
                    
                    let latitude = coordinateArray[0]
                    let longitude = coordinateArray[1]
                    
//                    print("Latitude is \(latitude.floatValue)")
//                    print("Longitude is \(longitude.floatValue)")
                    
                    location = CLLocationCoordinate2D(latitude: latitude.doubleValue, longitude:  longitude.doubleValue)
                    
                    let position = location!
                    let marker = GMSMarker(position: position)
                    marker.title = self.discovery?.title
                    marker.map = gmsMap
        
                    let camera = GMSCameraPosition.camera(withLatitude: position.latitude, longitude: position.longitude, zoom: 15)
                    gmsMap.camera = camera
                    
                    gmsMap.isMyLocationEnabled = true
                } else {
                    // Show them their own location, not the pin since it can't be extrapolated
                    if let position = gmsMap.myLocation?.coordinate {
                        let marker = GMSMarker(position: position)
                        marker.title = "Hello World"
                        marker.map = gmsMap
                        
                        let camera = GMSCameraPosition.camera(withLatitude: position.latitude, longitude: position.longitude, zoom: 15)
                        gmsMap.camera = camera
                    }
                }
                

            } catch {
                print("Error \(error)")
                
                // Show them their own location, not the pin since it can't be extrapolated
                if let position = gmsMap.myLocation?.coordinate {
                    let marker = GMSMarker(position: position)
                    marker.title = "Hello World"
                    marker.map = gmsMap
        
                    let camera = GMSCameraPosition.camera(withLatitude: position.latitude, longitude: position.longitude, zoom: 15)
                    gmsMap.camera = camera
                }
            }
            
            
        }
        
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let bottomPadding = window?.safeAreaInsets.bottom
            
            gmsMap.padding = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: self.view.frame.size.height - mapCellHeight - self.topbarHeight - (bottomPadding ?? 0.0), right: 0.0)
            
        } else {
            gmsMap.padding = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: self.view.frame.size.height - mapCellHeight - self.topbarHeight - 0.0, right: 0.0)
            
        }
        
        
        self.view.insertSubview(gmsMap, belowSubview: discoveryCollectionView)
    }
    
    override func userDidTapMap() {
        
        if let location = location {
            let vc = DiscoveryFullScreenMapViewController()
            vc.position = location
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    // MARK: CollectionViewDataSource , CollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let mapCell = collectionView.dequeueReusableCell(withReuseIdentifier: mapCellIdentifier, for: indexPath)
            mapCell.backgroundColor = .clear
            
            return mapCell
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailsCellIdentifier, for: indexPath) as! DiscoveryDetailsCollectionViewCell
            cell.priceLabel.text = "$ 90"
            cell.timeAwayLabel.text = "10 mins away"
            cell.descriptionLabel.text = "I’m looking for someone to come and clean my dorm room, its dirty and messy! Willing to pay $90."
            cell.descriptionLabel.sizeToFit()
            
            if let discovery = discovery {
                cell.priceLabel.text = "$ \(discovery.price ?? 0)"
                cell.titleLabel.text = discovery.title
                cell.descriptionLabel.text = discovery.description
            }
            
            cell.priceLabel.sizeToFit()
            cell.titleLabel.sizeToFit()
            cell.timeAwayLabel.sizeToFit()
            cell.descriptionLabel.sizeToFit()
            
            return cell
        } else if indexPath.row == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imagesCellIdentifier, for: indexPath) as! DiscoveryImagesCollectionViewCell
            // TODO: Fetch actual images of the discovery, instead of fake ones.
//            cell.imageInputs = pin?.imagesUrl ?? []
//            cell.setupInputs()
            
            if let discovery = discovery {
                cell.discovery = GetSurroundingDiscoveriesQuery.Data.GetSurroundingDiscovery.init(snapshot: discovery.snapshot)
            }
            
            
            return cell
            
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyCellIdentifier, for: indexPath)
        
        cell.backgroundColor = .white
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Map cell
        if indexPath.row == 0 {
            return CGSize.init(width: collectionView.frame.size.width, height: mapCellHeight)
        }
            // Detail cell
        else if indexPath.row == 1 {
            
            let size = CGSize.init(width: collectionView.frame.size.width - 16.0, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            
            let estimatedTitleFrame = NSString.init(string: discovery?.title ?? "").boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 30, weight: .semibold)], context: nil)
            
            let estimatedPriceFrame = NSString.init(string: "$ \(discovery?.price ?? 0)").boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 30, weight: .medium)], context: nil)
            
            let estimatedTimeFrame = NSString.init(string: "10 mins away").boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: .light)], context: nil)
            
            let estimatedDescriptionFrame = NSString.init(string: discovery?.description ?? "").boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium)], context: nil)
            
            
            return CGSize.init(width: collectionView.frame.size.width, height: estimatedTitleFrame.height + estimatedPriceFrame.height + estimatedTimeFrame.height + estimatedDescriptionFrame.height + 60.0)
            
        }
            // Image cell
        else if indexPath.row == 2 {
            return CGSize.init(width: collectionView.frame.size.width, height: 400.0)
        }
        
        
        return CGSize.init(width: collectionView.frame.size.width, height: 80.0)
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
