//
//  PinsNearbyCollectionView.swift
//  ServinV2
//
//  Created by Developer on 2018-05-22.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit

class PinsNearbyView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let titleLabel = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: self.frame.size.width, height: 25.0))
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textColor = UIColor.greyBackgroundColor.withAlphaComponent(0.7)
        titleLabel.text = "Explore pins nearby"
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        self.addSubview(titleLabel)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: 150, height: self.frame.size.height - 35.0)
        
        layout.scrollDirection = .horizontal
        
        let myCollectionView:UICollectionView = UICollectionView(frame: CGRect.init(x: 0.0, y: 35.0, width: self.frame.size.width, height: self.frame.size.height - 35.0), collectionViewLayout: layout)
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        
        myCollectionView.register(UINib.init(nibName: String.init(describing: PinsNearbyCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "MyCell")
        myCollectionView.backgroundColor = UIColor.white
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.showsVerticalScrollIndicator = false
        
        self.addSubview(myCollectionView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Data.allPins.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! PinsNearbyCollectionViewCell
        myCell.imageView.image = Data.allPins[indexPath.row]._images.first ?? #imageLiteral(resourceName: "room1")
        myCell.titleLabel.text = Data.allPins[indexPath.row]._title ?? " "
        myCell.priceLabel.text = "$ \(Data.allPins[indexPath.row]._price ?? 0)"
        myCell.distanceLabel.text = "4 mins away"
        
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let parentVC = self.parentContainerViewController() {
            let discoveryVC = UserDiscoveryViewController()
            discoveryVC.pin = Data.allPins[indexPath.row]
            parentVC.present(UINavigationController.init(rootViewController: discoveryVC), animated: true, completion: nil)
        }
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
