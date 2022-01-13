//
//  SlaveSearchResultsViewController.swift
//  Servin
//
//  Created by Munib Rahman on 2019-05-21.
//  Copyright © 2019 Voltic Labs. All rights reserved.
//

import UIKit
import Pulley

class SlaveSearchResultsViewController: UIViewController {
    
    let recommendedPinsCellIdentifier = "RecommendedPinsCell"
    var recommendedCellCount = 5
    
    var pulleyTapGestureRecognizer: UITapGestureRecognizer!
    var drawerTapView: UIView!
    
    var recommendedcvheightAnchor: NSLayoutConstraint?
    
    var discoveriesAroundMe = [DiscoveryQuery.Data.Discovery]() {
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
    
    var searchResultsTitleLabel: UILabel = {
        //        let titleLabel = UILabel.init(frame: CGRect.init(x: 20, y: y, width: width, height: 25.0))
        let titleLabel = UILabel.init()
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textColor = UIColor.greyBackgroundColor.withAlphaComponent(0.7)
        titleLabel.text = "Search Results"
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()

    lazy var recommendedPinsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        print("Width \(view.frame.size.width)")
        layout.estimatedItemSize = CGSize.init(width: view.frame.size.width, height: 220.0)
        
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
    
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(scrollView)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        
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
        
        
        scrollView.addSubview(searchResultsTitleLabel)
        searchResultsTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        searchResultsTitleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15).isActive = true
        searchResultsTitleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        scrollView.addSubview(recommendedPinsCollectionView)
        recommendedPinsCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        recommendedPinsCollectionView.topAnchor.constraint(equalTo: searchResultsTitleLabel.bottomAnchor, constant: 10).isActive = true
        recommendedPinsCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        recommendedcvheightAnchor = recommendedPinsCollectionView.heightAnchor.constraint(equalToConstant: CGFloat((220 * recommendedCellCount) + Int((UICollectionViewFlowLayout().minimumInteritemSpacing * CGFloat(recommendedCellCount))) + 20 ) )
        recommendedcvheightAnchor?.isActive = true
        
        recommendedPinsCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    @objc func userDidTapDrawer() {
        if let parentVC = self.parent as? MasterPulleyViewController {
            parentVC.setDrawerPosition(position: .partiallyRevealed, animated: true)
        }
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension SlaveSearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return discoveriesAroundMe.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: recommendedPinsCellIdentifier, for: indexPath) as! SavedPinsCollectionViewCell
        
        
        let discovery = discoveriesAroundMe[indexPath.item]
        myCell.pinTitle.text = discovery.title
        myCell.pinPrice.text = "$ \(discovery.price ?? 0)"
        myCell.timeAway.text = "4 mins away"
        
        if let image_0 = discovery.image_0, let ICONUrl = image_0.MEDImageKeyS3() {
            myCell.pinImageView.loadImageUsingS3Key(key: ICONUrl)
        }
        
        myCell.discoveryId = discovery.discoveryId
        myCell.isSaved = discovery.isSaved ?? false

        return myCell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Did select item")
            if let parentVC = self.parent {
                let discovery = discoveriesAroundMe[indexPath.item]
                let discoveryVC = UserDiscoveryViewController()
                discoveryVC.pin = GetSurroundingDiscoveriesQuery.Data.GetSurroundingDiscovery.init(snapshot: discovery.snapshot)
                parentVC.present(UINavigationController.init(rootViewController: discoveryVC), animated: true, completion: nil)
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: collectionView.frame.size.width, height: 220)
    }
}
