//
//  MessageTableViewCell.swift
//  ServinV2
//
//  Created by Developer on 2018-07-03.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet var contentImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentImageView.contentMode = .scaleAspectFill
        contentImageView.clipsToBounds = true
        // Initialization code
        
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    func messageHasBeen(read: Bool) {
        if read {
            titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
            detailLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
            priceLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
            
            timeLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        } else {
            titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
            detailLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .semibold)
            priceLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
            
            timeLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .semibold)
        }
    }
    
}
