//
//  SlaveDiscoveriesViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-21.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import Pulley
import GoogleMaps
import AWSS3
import SwiftyJSON

class SlaveDiscoveriesViewController: UIViewController, UIScrollViewDelegate, PulleyDrawerViewControllerDelegate {
    
    

    var scrollView: UIScrollView! = nil
    var scrollViewHeight: CGFloat = 0.0
    var pulleyTapGestureRecognizer: UITapGestureRecognizer!
    var drawerTapView: UIView!
    
    var discoveriesAroundMe = [GetSurroundingDiscoveriesQuery.Data.GetSurroundingDiscovery?]()
    
    var pinsNearbyCollectionView: UICollectionView!
    var recommendedPinsCollectionView: UICollectionView!
    
    // PinsNearby
    // RecommendedPins
    
    let pinsNearbyCellIdentifier = "PinsNearbyCell"
    let recommendedPinsCellIdentifier = "RecommendedPinsCell"
    
    let recommendedCellCount = ServinData.allPins.count
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView.init(frame: self.view.bounds)
        
        let nearbyPinsSize = setupPinsNearbyCollectionView(x: 0.0, y: 15.0, width: self.view.frame.size.width, height: 212.0)

        let recommendedPinSize = setupRecommendedPinsCollectionView(x: 0, y: nearbyPinsSize.height + 40.0, width: self.view.frame.size.width, height: CGFloat((220 * recommendedCellCount) + Int((UICollectionViewFlowLayout().minimumInteritemSpacing * CGFloat(recommendedCellCount))) + 35 + 20))
        
        
        // TODO: Calculate the actual height here
        scrollViewHeight = (nearbyPinsSize.height + recommendedPinSize.height)
        scrollView.contentSize = CGSize.init(width: self.view.frame.size.width, height: scrollViewHeight)
        scrollView.scrollsToTop = true

        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.bounces = false
        
        scrollView.delegate = self
        
        
        // This ensures that you dont get extra spacing at the top when you try and scroll down.
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        
        self.view.addSubview(scrollView)
        
        pulleyTapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(userDidTapDrawer))
        
        drawerTapView = UIView.init(frame: self.view.frame)
        drawerTapView.backgroundColor = .clear
        
        drawerTapView.addGestureRecognizer(pulleyTapGestureRecognizer)
        
        self.view.addSubview(drawerTapView)
        drawerTapView.isUserInteractionEnabled = false
    }
    
    @objc func userDidTapDrawer() {
        if let parentVC = self.parent as? MasterPulleyViewController {
            parentVC.setDrawerPosition(position: .partiallyRevealed, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // We listen to the drawer's position and then disable/enable scrolling of the scroll view by
    // adjusting its content size
    func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat) {
        
        if drawer.drawerPosition == .open {
            scrollView.contentSize = CGSize.init(width: scrollView.contentSize.width, height: scrollViewHeight)
        } else {
            scrollView.contentSize = CGSize.init(width: scrollView.contentSize.width, height: 0)
        }
        
        
        if drawer.drawerPosition == PulleyPosition.collapsed {
            drawerTapView.isUserInteractionEnabled = true
        } else {
            drawerTapView.isUserInteractionEnabled = false
        }

    }
    
    func setupPinsNearbyCollectionView(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGSize {
        
        let titleLabel = UILabel.init(frame: CGRect.init(x: 20, y: y, width: width, height: 25.0))
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textColor = UIColor.greyBackgroundColor.withAlphaComponent(0.7)
        titleLabel.text = "Explore pins nearby"
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        self.scrollView.addSubview(titleLabel)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: 150, height: height - 35.0)
        
        layout.scrollDirection = .horizontal
        
        pinsNearbyCollectionView = UICollectionView(frame: CGRect.init(x: 0.0, y: 35.0 + y, width: width, height: height - 35.0), collectionViewLayout: layout)
        pinsNearbyCollectionView.dataSource = self
        pinsNearbyCollectionView.delegate = self
        
        pinsNearbyCollectionView.register(UINib.init(nibName: String.init(describing: PinsNearbyCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: pinsNearbyCellIdentifier)
        pinsNearbyCollectionView.backgroundColor = UIColor.white
        
        pinsNearbyCollectionView.delegate = self
        pinsNearbyCollectionView.dataSource = self
        
        pinsNearbyCollectionView.showsHorizontalScrollIndicator = false
        pinsNearbyCollectionView.showsVerticalScrollIndicator = false
        
        self.scrollView.addSubview(pinsNearbyCollectionView)
        
        return CGSize.init(width: self.view.frame.size.width, height: titleLabel.frame.size.height + pinsNearbyCollectionView.frame.size.height)
    }
    
    func setupRecommendedPinsCollectionView(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGSize {
        
        let titleLabel = UILabel.init(frame: CGRect.init(x: 20, y: y, width: width, height: 25.0))
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textColor = UIColor.greyBackgroundColor.withAlphaComponent(0.7)
        titleLabel.text = "Recommended for you"
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        self.scrollView.addSubview(titleLabel)
        
        let layout = UICollectionViewFlowLayout.init()
        layout.estimatedItemSize = CGSize.init(width: view.frame.size.width, height: 220.0)
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        
        recommendedPinsCollectionView = UICollectionView(frame: CGRect.init(x: 0.0, y: 35.0 + y, width:width, height: height - 35.0), collectionViewLayout: layout)
        
        recommendedPinsCollectionView.register(SavedPinsCollectionViewCell.self, forCellWithReuseIdentifier: recommendedPinsCellIdentifier)
        
        
        
        recommendedPinsCollectionView.backgroundColor = UIColor.white
        
        recommendedPinsCollectionView.delegate = self
        recommendedPinsCollectionView.dataSource = self
        
        recommendedPinsCollectionView.showsHorizontalScrollIndicator = false
        recommendedPinsCollectionView.showsVerticalScrollIndicator = false
        
        recommendedPinsCollectionView.isScrollEnabled = false
        
        self.scrollView.addSubview(recommendedPinsCollectionView)
        
        return CGSize.init(width: width, height: titleLabel.frame.size.height + recommendedPinsCollectionView.frame.size.height + 180.0)
    }

}

extension SlaveDiscoveriesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == pinsNearbyCollectionView {
            return discoveriesAroundMe.count
        } else {
            return recommendedCellCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == pinsNearbyCollectionView {
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: pinsNearbyCellIdentifier, for: indexPath) as! PinsNearbyCollectionViewCell            
            
            if let discovery = discoveriesAroundMe[indexPath.item] {
                myCell.titleLabel.text = discovery.title
                myCell.priceLabel.text = "$ \(discovery.price ?? 0)"
                myCell.distanceLabel.text = "4 mins away"
                
                if let image_0 = discovery.image_0, let ICONUrl = image_0.ICONImageKeyS3() {
                    myCell.imageView.loadImageUsingS3Key(key: ICONUrl)
                }
            }

            return myCell
        } else {
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: recommendedPinsCellIdentifier, for: indexPath) as! SavedPinsCollectionViewCell
            
            myCell.pinImageView.image = ServinData.allPins[indexPath.row]._images.first ?? #imageLiteral(resourceName: "1")
            myCell.pinTitle.text = ServinData.allPins[indexPath.row]._title ?? " "
            myCell.pinPrice.text = "$ \(ServinData.allPins[indexPath.row]._price ?? 0)"
            myCell.timeAway.text = "5 mins away"
            myCell.isSaved = ServinData.allPins[indexPath.row].isSaved
            return myCell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == pinsNearbyCollectionView {
            if let parentVC = self.parent, let discovery = discoveriesAroundMe[indexPath.item] {
                let discoveryVC = UserDiscoveryViewController()
                discoveryVC.pin = discovery
                parentVC.present(UINavigationController.init(rootViewController: discoveryVC), animated: true, completion: nil)
            }
        }
    }
}


extension SlaveDiscoveriesViewController: SlaveMapViewControllerDelegate {
    
    func didLongPressOnMap(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
    }
    
    func didSelectMarker(pin: Discovery) {
        
        if let offset = ServinData.allPins.index(where: {$0._price == pin._price}) {
            // do something with fooOffset
            
            let indexPath = IndexPath.init(row: offset, section: 0)
            pinsNearbyCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            // item could not be found
        }
    }
    
}























