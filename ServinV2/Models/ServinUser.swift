//
//  User.swift
//  ServinV2
//
//  Created by Developer on 2018-06-20.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import Foundation
import UIKit

class ServinUser {
    
    var _firstName: String?
    var _lastName: String?
    var _institution: String?
    var _profilePicture: UIImage?
    var _pinsOnMap =  [Discovery?]()
    var _about: String?
    var _profilePictureUrl: String?
    
    init(firstName: String?, lastName: String?, profilePicture: UIImage?, institution: String, about: String?) {
        self._firstName = firstName
        self._lastName = lastName
        self._institution = institution
        self._profilePicture = profilePicture
        self._about = about
    }
    
}
