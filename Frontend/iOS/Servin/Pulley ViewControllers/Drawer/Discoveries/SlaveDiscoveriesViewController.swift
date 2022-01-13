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
import SkeletonView


// https://stackoverflow.com/questions/48216808/programmatic-uiscrollview-with-autolayout
class SlaveDiscoveriesViewController: UIViewController, PulleyDrawerViewControllerDelegate {
    
    
    var scrollViewHeight: CGFloat = 0.0
    var pulleyTapGestureRecognizer: UITapGestureRecognizer!
    var drawerTapView: UIView!
    
    var discoveriesAroundMe = [GetSurroundingDiscoveriesQuery.Data.GetSurroundingDiscovery?]() {
        didSet {
            recommendedCellCount = discoveriesAroundMe.count
            recommendedcvheightAnchor?.isActive = false
            
            // TODO: Make this nicer somehow, if there is a better way, find it.
            recommendedcvheightAnchor = recommendedPinsCollectionView.heightAnchor.constraint(equalToConstant: CGFloat((220 * recommendedCellCount) + Int((UICollectionViewFlowLayout().minimumInteritemSpacing * CGFloat(recommendedCellCount))) + 20 ) )
            recommendedcvheightAnchor?.isActive = true
            
//
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            
            
            
//            if discoveriesAroundMe.count == 0 {
//                pinsNearbyCollectionView.setEmptyMessage("No discoveries in this area, try broadening your search.", image: nil)
//            } else {
//                pinsNearbyCollectionView.setEmptyMessage("", image: nil)
//            }
        }
    }
    

    var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.scrollsToTop = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
       return scrollView
        
    }()
    
    
//    var contentView: UIView = {
//        let contentView = UIView.init()
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.backgroundColor = UIColor.brown
//        return contentView
//    }()
    
    
    

    lazy var recommendedPinsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        print("Width \(view.frame.size.width)")
        layout.estimatedItemSize = CGSize.init(width: view.frame.size.width, height: 220.0)
        
        
//        let recommendedPinsCollectionView = UICollectionView(frame: CGRect.init(x: 0.0, y: 35.0 + y, width:width, height: height - 35.0), collectionViewLayout: layout)
        
        let recommendedPinsCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        recommendedPinsCollectionView.register(SavedPinsCollectionViewCell.self, forCellWithReuseIdentifier: recommendedPinsCellIdentifier)

        recommendedPinsCollectionView.backgroundColor = UIColor.white
        
        recommendedPinsCollectionView.delegate = self
        recommendedPinsCollectionView.dataSource = self
        
        recommendedPinsCollectionView.showsHorizontalScrollIndicator = false
        recommendedPinsCollectionView.showsVerticalScrollIndicator = false
        
        recommendedPinsCollectionView.isScrollEnabled = false
        recommendedPinsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return recommendedPinsCollectionView
    }()
    
    var recommendedForYouTitleLabel: UILabel = {
        //        let titleLabel = UILabel.init(frame: CGRect.init(x: 20, y: y, width: width, height: 25.0))
        let titleLabel = UILabel.init()
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textColor = UIColor.greyBackgroundColor.withAlphaComponent(0.7)
        titleLabel.text = "Recommended for you"
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    
    var explorePinsNearbyTitleLabel: UILabel = {
        //        let titleLabel = UILabel.init(frame: CGRect.init(x: 20, y: y, width: width, height: 25.0))
        let titleLabel = UILabel.init()
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textColor = UIColor.greyBackgroundColor.withAlphaComponent(0.7)
        titleLabel.text = "Explore pins nearby"
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.backgroundColor = .white
        return titleLabel
    }()
    
    lazy var pinsNearbyCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: 150, height: 177)
        
        layout.scrollDirection = .horizontal
        
        //        let pinsNearbyCollectionView = UICollectionView(frame: CGRect.init(x: 0.0, y: 35.0 + y, width: width, height: height - 35.0), collectionViewLayout: layout)
        let pinsNearbyCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        pinsNearbyCollectionView.dataSource = self
        pinsNearbyCollectionView.delegate = self
        
        pinsNearbyCollectionView.register(UINib.init(nibName: String.init(describing: PinsNearbyCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: pinsNearbyCellIdentifier)
        pinsNearbyCollectionView.backgroundColor = UIColor.white
        
        
        pinsNearbyCollectionView.showsHorizontalScrollIndicator = false
        pinsNearbyCollectionView.showsVerticalScrollIndicator = false
        
        pinsNearbyCollectionView.delegate = self
        pinsNearbyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        pinsNearbyCollectionView.isSkeletonable = true
        
        return pinsNearbyCollectionView
    }()
    
    // PinsNearby
    // RecommendedPins
    
    let pinsNearbyCellIdentifier = "PinsNearbyCell"
    let recommendedPinsCellIdentifier = "RecommendedPinsCell"
    
    var recommendedCellCount = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.isSkeletonable = false
        
        self.view.addSubview(scrollView)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        setupPinsNearbyCollectionView()
        
        
        // This ensures that you dont get extra spacing at the top when you try and scroll down.
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        
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
            scrollView.isScrollEnabled = true
        } else {
            scrollView.isScrollEnabled = false
        }
        
        
        if drawer.drawerPosition == PulleyPosition.collapsed {
            drawerTapView.isUserInteractionEnabled = true
        } else {
            drawerTapView.isUserInteractionEnabled = false
        }

    }
    
    var recommendedcvheightAnchor: NSLayoutConstraint?

    
    func setupPinsNearbyCollectionView() {
        
        scrollView.addSubview(explorePinsNearbyTitleLabel)
        explorePinsNearbyTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        explorePinsNearbyTitleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15).isActive = true
        explorePinsNearbyTitleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
//        explorePinsNearbyTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        
        scrollView.addSubview(pinsNearbyCollectionView)
        pinsNearbyCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        pinsNearbyCollectionView.topAnchor.constraint(equalTo: explorePinsNearbyTitleLabel.bottomAnchor, constant: 10).isActive = true
        pinsNearbyCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        pinsNearbyCollectionView.heightAnchor.constraint(equalToConstant: 177).isActive = true

//        pinsNearbyCollectionView.isSkeletonable = true
//        pinsNearbyCollectionView.prepareSkeleton { (done) in
//            print("ABLE TO SHOW SKELETON NOW")
//            self.pinsNearbyCollectionView.showAnimatedGradientSkeleton()
////            self.view.showAnimatedSkeleton()
//        }
        
        scrollView.addSubview(recommendedForYouTitleLabel)
        recommendedForYouTitleLabel.leadingAnchor.constraint(equalTo: explorePinsNearbyTitleLabel.leadingAnchor).isActive = true
        recommendedForYouTitleLabel.topAnchor.constraint(equalTo: pinsNearbyCollectionView.bottomAnchor, constant: 10).isActive = true
        recommendedForYouTitleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true

        scrollView.addSubview(recommendedPinsCollectionView)
        recommendedPinsCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        recommendedPinsCollectionView.topAnchor.constraint(equalTo: recommendedForYouTitleLabel.bottomAnchor, constant: 10).isActive = true
        recommendedPinsCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        recommendedcvheightAnchor = recommendedPinsCollectionView.heightAnchor.constraint(equalToConstant: CGFloat((220 * recommendedCellCount) + Int((UICollectionViewFlowLayout().minimumInteritemSpacing * CGFloat(recommendedCellCount))) + 20 ) )
        recommendedcvheightAnchor?.isActive = true
        
        recommendedPinsCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
    }

}

extension SlaveDiscoveriesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if discoveriesAroundMe.count == 0 {
            pinsNearbyCollectionView.setEmptyMessage("No pins in this area, try increasing your search radius", image: #imageLiteral(resourceName: "world_icon"))
            recommendedPinsCollectionView.setEmptyMessage("Recommendations are based on your browsing history.", image: nil)
        } else {
            pinsNearbyCollectionView.restore()
            recommendedPinsCollectionView.restore()
        }
        
        if collectionView == pinsNearbyCollectionView {
            return discoveriesAroundMe.count
        } else {
            return discoveriesAroundMe.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == pinsNearbyCollectionView {
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: pinsNearbyCellIdentifier, for: indexPath) as! PinsNearbyCollectionViewCell            
            
            if let discovery = discoveriesAroundMe[indexPath.item] {
                myCell.titleLabel.text = discovery.title
                myCell.priceLabel.text = "$ \(discovery.price ?? 0)"
                myCell.distanceLabel.text = "5 mins away"
                
                if let image_0 = discovery.image_0, let ICONUrl = image_0.ICONImageKeyS3() {
                    myCell.imageView.loadImageUsingS3Key(key: ICONUrl)
                }
            }

            return myCell
        } else {
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: recommendedPinsCellIdentifier, for: indexPath) as! SavedPinsCollectionViewCell
            
            
            if let discovery = discoveriesAroundMe[indexPath.item] {
                myCell.pinTitle.text = discovery.title
                myCell.pinPrice.text = "$ \(discovery.price ?? 0)"
                myCell.timeAway.text = "4 mins away"

                if let image_0 = discovery.image_0, let ICONUrl = image_0.MEDImageKeyS3() {
                    myCell.pinImageView.loadImageUsingS3Key(key: ICONUrl)
                }
                myCell.discoveryId = discovery.discoveryId
                myCell.isSaved = discovery.isSaved ?? false
            }
//            myCell.pinImageView.image = ServinData.allPins[indexPath.row]._images.first ?? #imageLiteral(resourceName: "1")
//            myCell.pinTitle.text = ServinData.allPins[indexPath.row]._title ?? " "
//            myCell.pinPrice.text = "$ \(ServinData.allPins[indexPath.row]._price ?? 0)"
//            myCell.timeAway.text = "5 mins away"
//            myCell.isSaved = ServinData.allPins[indexPath.row].isSaved
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
        
        else if collectionView == recommendedPinsCollectionView {
            if let parentVC = self.parent, let discovery = discoveriesAroundMe[indexPath.item] {
                let discoveryVC = UserDiscoveryViewController()
                discoveryVC.pin = discovery
                parentVC.present(UINavigationController.init(rootViewController: discoveryVC), animated: true, completion: nil)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == recommendedPinsCollectionView {
            return CGSize.init(width: collectionView.frame.size.width, height: 220)
        }
        
        return CGSize.init(width: 150, height: 177)
    }
}

extension SlaveDiscoveriesViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        if skeletonView == pinsNearbyCollectionView {
            print("Yes its the same collectionview")
            return pinsNearbyCellIdentifier
        } else {
            return recommendedPinsCellIdentifier
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return 1
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























