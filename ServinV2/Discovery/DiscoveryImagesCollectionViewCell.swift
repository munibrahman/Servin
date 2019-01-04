//
//  DiscoveryImagesCollectionViewCell.swift
//  ServinV2
//
//  Created by Developer on 2018-06-12.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import ImageSlideshow
import AlamofireImage

class DiscoveryImagesCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {

    var mySlideShow = ImageSlideshow()
    
    var imageInputs = [String]()
    var inputSources = [InputSource]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.gray
        
        mySlideShow = ImageSlideshow.init(frame: self.frame)
        

        // Settings must be done BEFORE images are to be loaded, otherwise nothing works...
        mySlideShow.circular = false
        mySlideShow.contentScaleMode = .scaleAspectFill

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        mySlideShow.addGestureRecognizer(gestureRecognizer)
        
        
        self.addSubview(mySlideShow)
    }
    
    func setupInputs() {
        for url in imageInputs {
            inputSources.append(AlamofireSource(urlString: url)!)
        }
        
        mySlideShow.setImageInputs(inputSources)
    }
    
    @objc func didTap() {
        
        if let parentVC = self.parentContainerViewController() {
            mySlideShow.presentFullScreenController(from: parentVC)
        }
        
    }

}
