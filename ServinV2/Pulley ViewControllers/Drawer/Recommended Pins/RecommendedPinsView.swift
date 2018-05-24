//
//  PinsNearbyCollectionView.swift
//  ServinV2
//
//  Created by Developer on 2018-05-22.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit

class RecommendedPinsView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let titleLabel = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: self.frame.size.width, height: 25.0))
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textColor = UIColor.greyBackgroundColor.withAlphaComponent(0.7)
        titleLabel.text = "Recommended just for you"
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        self.addSubview(titleLabel)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
        layout.itemSize = CGSize(width: (self.frame.size.width - 60.0) / 2, height: 240.0)
        
        layout.scrollDirection = .vertical
        
        let myCollectionView:UICollectionView = UICollectionView(frame: CGRect.init(x: 0.0, y: 35.0, width: self.frame.size.width, height: self.frame.size.height - 35.0), collectionViewLayout: layout)
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        
        myCollectionView.register(UINib.init(nibName: "RecommendedPinsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyCell")
        myCollectionView.backgroundColor = UIColor.white
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.showsVerticalScrollIndicator = false
        
        myCollectionView.isScrollEnabled = false
        
        self.addSubview(myCollectionView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! RecommendedPinsCollectionViewCell
        
        myCell.backgroundColor = .red
        return myCell
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

