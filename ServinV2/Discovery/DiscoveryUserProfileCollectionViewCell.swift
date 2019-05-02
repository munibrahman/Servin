//
//  DiscoveryUserProfileCollectionViewCell.swift
//  ServinV2
//
//  Created by Developer on 2018-06-13.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
 
class DiscoveryUserProfileCollectionViewCell: UICollectionViewCell {

    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userFirstNameLabel: UILabel!
    @IBOutlet var userUniversityLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.userImageView.contentMode = .scaleAspectFill
        self.userImageView.layer.cornerRadius = userImageView.frame.size.width / 2.0
        self.userImageView.clipsToBounds = true
        
        self.backgroundColor = .white
    }

}
