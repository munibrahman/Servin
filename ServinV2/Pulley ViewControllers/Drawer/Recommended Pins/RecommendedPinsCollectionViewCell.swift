//
//  RecommendedPinsCollectionViewCell.swift
//  ServinV2
//
//  Created by Developer on 2018-05-22.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit

class RecommendedPinsCollectionViewCell: UICollectionViewCell {

    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imageView.layer.cornerRadius = 2.0
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
    }

}
