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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.gray
        
        mySlideShow = ImageSlideshow.init(frame: self.frame)
        

        // Settings must be done BEFORE images are to be loaded, otherwise nothing works...
        mySlideShow.circular = false
        mySlideShow.contentScaleMode = .scaleAspectFill
        
        mySlideShow.setImageInputs([AlamofireSource(urlString: "https://picsum.photos/400/300/?random")!,
                                    AlamofireSource(urlString: "https://picsum.photos/500/300/?random")!,
                                    AlamofireSource(urlString: "https://picsum.photos/700/300/?random")!,
                                    AlamofireSource(urlString: "https://picsum.photos/400/600/?random")!,
                                    AlamofireSource(urlString: "https://picsum.photos/200/300/?random")!,
                                    AlamofireSource(urlString: "https://picsum.photos/600/300/?random")!,
                                    AlamofireSource(urlString: "https://picsum.photos/800/500/?random")!])
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        mySlideShow.addGestureRecognizer(gestureRecognizer)
        
        self.addSubview(mySlideShow)
    }
    
    @objc func didTap() {
        
        if let parentVC = self.parentContainerViewController() {
            mySlideShow.presentFullScreenController(from: parentVC)
        }
        
    }

}
