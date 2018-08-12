//
//  DiscoveryDetailsCollectionViewCell.swift
//  ServinV2
//
//  Created by Developer on 2018-06-12.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit

class DiscoveryDetailsCollectionViewCell: UICollectionViewCell {

    var titleLabel: UILabel!
    var timeAwayLabel: UILabel!
    var priceLabel: UILabel!
    
    
    var descriptionLabel: UILabel!
    
    let heightPaddings: CGFloat = 42
    let widthPaddings: CGFloat = 16
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .white
        
        titleLabel = UILabel.init()
        
        self.contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8).isActive = true
        
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        titleLabel.textColor = UIColor.blackFontColor
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 3
        
        
        
        
        
        
        
        priceLabel = UILabel.init()
        self.contentView.addSubview(priceLabel)
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        
        priceLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        priceLabel.textColor = UIColor.blackFontColor.withAlphaComponent(0.8)
        priceLabel.numberOfLines = 1
        priceLabel.adjustsFontSizeToFitWidth = true
        
        
        
        
        timeAwayLabel = UILabel.init()
        self.contentView.addSubview(timeAwayLabel)
        
        timeAwayLabel.translatesAutoresizingMaskIntoConstraints = false
        timeAwayLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor).isActive = true
        timeAwayLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8).isActive = true
        timeAwayLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor).isActive = true
        
        timeAwayLabel.font = UIFont.systemFont(ofSize: 13, weight: .light)
        timeAwayLabel.textColor = UIColor.blackFontColor.withAlphaComponent(0.8)
        timeAwayLabel.numberOfLines = 1
        
        
        descriptionLabel = UILabel.init()
        
        self.contentView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.leadingAnchor.constraint(equalTo: timeAwayLabel.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: timeAwayLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8).isActive = true
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        descriptionLabel.textColor = UIColor.blackFontColor.withAlphaComponent(0.9)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
