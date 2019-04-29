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
import SwiftyJSON

class DiscoveryImagesCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {

    var mySlideShow = ImageSlideshow()
    
    var imageInputs = [String]()
    var inputSources = [InputSource]()
    var discovery: GetSurroundingDiscoveriesQuery.Data.GetSurroundingDiscovery? {
        didSet {
            self.setupInputs()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.gray
        
        mySlideShow = ImageSlideshow.init(frame: self.frame)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        mySlideShow.addGestureRecognizer(gestureRecognizer)
        
        
        self.addSubview(mySlideShow)

        // Settings must be done BEFORE images are to be loaded, otherwise nothing works...
        mySlideShow.circular = false
        mySlideShow.contentScaleMode = .scaleAspectFill

        
    }
    
    func setupInputs() {
        
        if let discovery = discovery {
            print("Discovery is existant")
            if let image_0 = discovery.image_0, let data = image_0.data(using: .utf8, allowLossyConversion: false) {
                do {
                    let json = try JSON.init(data: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    print("JSON DATA \(json)")
                    //                    print(json["original"].stringValue)
                    //                    myCell.imageView.loadImageUsingS3Key(key: json["ICON"].stringValue)
                    inputSources.append(S3Source.init(key: json["MAX"].stringValue))
                    
                } catch {
                    print("Error \(error)")
                }
            }
            
            if let image_1 = discovery.image_1, let data = image_1.data(using: .utf8, allowLossyConversion: false) {
                do {
                    let json = try JSON.init(data: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    print("JSON DATA \(json)")
                    //                    print(json["original"].stringValue)
                    //                    myCell.imageView.loadImageUsingS3Key(key: json["ICON"].stringValue)
                    inputSources.append(S3Source.init(key: json["MAX"].stringValue))
                    
                } catch {
                    print("Error \(error)")
                }
            }
            
            mySlideShow.setImageInputs(inputSources)
            
            
        }
        
        
        //        for url in imageInputs {
        //            inputSources.append(AlamofireSource(urlString: url)!)
        //        }
        
//        for url in imageInputs {
//            inputSources.append(AlamofireSource(urlString: url)!)
//        }
//
//        mySlideShow.setImageInputs(inputSources)
    }
    
    @objc func didTap() {
        print("Did tap")
        if let parentVC = self.parentContainerViewController() {
            mySlideShow.presentFullScreenController(from: parentVC)
        }
        
    }

}
