//
//  Pin.swift
//  ServinV2
//
//  Created by Developer on 2018-06-20.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import Foundation
import MapKit
import UIKit

enum typeOfRequest {
    case offer
    case request
}

class Discovery {
    
    var _id: String?
    var _title: String?
    var _desctiption: String?
    var _price: Int?
    var _views: Int?
    var _location: CLLocationCoordinate2D?
    var _images = [UIImage?]()
    var typeOfRequest: typeOfRequest?
    var isSaved = false
    
    var imagesUrl = [String]()
    
    var user: ServinUser?
    
    
    init(id: String?, title: String?, description: String?, price: Int?, views: Int?, location: CLLocationCoordinate2D?, images: [UIImage?], typeOfRequest: typeOfRequest, isSaved: Bool) {
        
        self._id = id
        self._title = title
        self._desctiption = description
        self._price = price
        self._views = views
        self._location = location
        self._images = images
        self.typeOfRequest = typeOfRequest
        self.isSaved = isSaved
    }
    
    func add(image: UIImage?) {
        self._images.append(image)
    }
    
    
}
