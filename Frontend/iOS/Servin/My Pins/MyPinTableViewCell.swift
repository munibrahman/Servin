//
//  MyPinUITableViewCell.swift
//  ServinV2
//
//  Created by Developer on 2018-06-19.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit

class MyPinTableViewCell: UITableViewCell {
    
    var pinImageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.blackFontColor
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    
    var priceLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.blackFontColor
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var viewsLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.blackFontColor
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func setupViews() {
        print("Setup views")
        
        addSubview(pinImageView)
        pinImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        pinImageView.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        pinImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6).isActive = true
        pinImageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: pinImageView.trailingAnchor, constant: 8).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 11).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(priceLabel)
        priceLabel.leadingAnchor.constraint(equalTo: pinImageView.trailingAnchor, constant: 8).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        addSubview(viewsLabel)
        viewsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        viewsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        viewsLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
