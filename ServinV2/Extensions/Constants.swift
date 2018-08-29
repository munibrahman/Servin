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

    
    static let googleMapsApiKey = "AIzaSyAoqms5Li-1iHtwPmE_EPFFG9ZLqQex3CY"
    static let googleMapsDirectionKey = "AIzaSyAS70BbAapdWTm52ujbq4EKrIlE8-MvZGs"
    
    static let stripePublishableKey = "pk_test_eLAT9Nvbd7M9F3hnNX2EWO4k"
    
    static let appleMerchantIdentifier = "merchant.com.servin"

    static fileprivate var pulleyMasterController: MasterPulleyViewController? = nil
    
    static func getMainContentVC() -> MasterPulleyViewController {
        
        
        if let pulleyVC = pulleyMasterController {
            return pulleyVC
        }
        
        let mainContentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SlaveMapViewController") as! SlaveMapViewController
        
        let drawerContentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SlaveDiscoveriesViewController") as! SlaveDiscoveriesViewController
        
        let drawerPostAdVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SlavePostAdViewController") as! SlavePostAdViewController
        
        let pulleyController = MasterPulleyViewController(contentViewController: mainContentVC, drawerViewController: drawerContentVC)
        
        mainContentVC.delegate = pulleyController
        mainContentVC.mapDelegate = drawerContentVC
        
        pulleyController.myMapViewController = mainContentVC
        pulleyController.myDiscoveriesViewController = drawerContentVC
        pulleyController.myPostAdViewController = drawerPostAdVC
        
        Constants.pulleyMasterController = pulleyController
        return pulleyController
    }
    
}


