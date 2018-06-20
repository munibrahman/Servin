//
//  MyPinUITableViewCell.swift
//  ServinV2
//
//  Created by Developer on 2018-06-19.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit

class MyPinTableViewCell: UITableViewCell {
    
    @IBOutlet var pinImageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var viewsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        pinImageView.contentMode = .scaleAspectFill
        pinImageView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
