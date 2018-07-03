//
//  User.swift
//  ServinV2
//
//  Created by Developer on 2018-06-20.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    var _firstName: String?
    var _lastName: String?
    var _institution: String?
    var _profilePicture: UIImage?
    var _pinsOnMap =  [Pin?]()
    
    init(firstName: String?, lastName: String?, profilePicture: UIImage?, institution: String) {
        self._firstName = firstName
        self._lastName = lastName
        self._institution = institution
        self._profilePicture = profilePicture
    }
    
}
