//
//  PinsNearbyCollectionViewCell.swift
//  ServinV2
//
//  Created by Developer on 2018-05-22.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit

class PinsNearbyCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imageView.layer.cornerRadius = 2.0
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
    }

}
