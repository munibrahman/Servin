//
//  Constants.swift
//  ServinV2
//
//  Created by Developer on 2018-05-07.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import Foundation
import UIKit


class Constants {
    
    static var searchBarFrame: CGRect? = nil
    static var recommendedCellHeight = 240.0
    //static var pinsNearbyCellHeight =
    
    static let googleMapsApiKey = "AIzaSyAGFQhWxsHh3UpGzvoTzB4flwsV_eCYODk"

    fileprivate var pulleyMasterController: MasterPulleyViewController? = nil
    
    func getMainContentVC() -> MasterPulleyViewController {
        
        
        if let pulleyVC = pulleyMasterController {
            return pulleyVC
        }
        
        let mainContentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SlaveMapViewController") as! SlaveMapViewController
        
        let drawerContentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SlaveDiscoveriesViewController") as! SlaveDiscoveriesViewController
        
        let drawerPostAdVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SlavePostAdViewController") as! SlavePostAdViewController
        
        let pulleyController = MasterPulleyViewController(contentViewController: mainContentVC, drawerViewController: drawerContentVC)
        
        mainContentVC.delegate = pulleyController
        
        pulleyController.myMapViewController = mainContentVC
        pulleyController.myDiscoveriesViewController = drawerContentVC
        pulleyController.myPostAdViewController = drawerPostAdVC
        
        self.pulleyMasterController = pulleyController
        return pulleyController
    }
    
}


