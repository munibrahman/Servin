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
    
    var testimageView: UIImageView!
    
    // TODO: Fix constrains on th actual image view instead of the test imageview.
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        
        testimageView = UIImageView.init(frame: menuOptionImageView.frame)
//        testimageView.backgroundColor = .blue
        testimageView.clipsToBounds = true
        testimageView.contentMode = .center
        
        testimageView.image = #imageLiteral(resourceName: "messages_icon")
        self.addSubview(testimageView)
        
//        menuOptionLabel.backgroundColor = .red
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
