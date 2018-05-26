//
//  SideMenuTableViewCell.swift
//  ServinV2
//
//  Created by Developer on 2018-05-04.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {

    @IBOutlet var menuOptionImageView: UIImageView!
    @IBOutlet var menuOptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
