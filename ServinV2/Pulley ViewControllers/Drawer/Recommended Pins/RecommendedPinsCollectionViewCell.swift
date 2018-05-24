//
//  RecommendedPinsCollectionViewCell.swift
//  ServinV2
//
//  Created by Developer on 2018-05-22.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit

class RecommendedPinsCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.cornerRadius = 2.0
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }

}
