//
//  DeeplinkNavigator.swift
//  Deeplinks
//
//  Created by Stanislav Ostrovskiy on 5/25/17.
//  Copyright © 2017 Stanislav Ostrovskiy. All rights reserved.
//

import Foundation
import UIKit

class DeeplinkNavigator {
    
    static let shared = DeeplinkNavigator()
    private init() { }
    
    var alertController = UIAlertController()
    
    func proceedToDeeplink(_ type: DeeplinkType) {
        switch type {
        case .messages(.root):
            showMessages()
        case .messages(.details(id: let id)):
            displayAlert(title: "Messages Details \(id)")
        case .dropNewPin:
            displayAlert(title: "Drop a new pin")
        case .myPins:
            displayAlert(title: "My Pins")
        case .savedPins:
            displayAlert(title: "Saved pins")
        case .verification:
            displayAlert(title: "Check verification")
   
        }
    }
    
    private func displayAlert(title: String) {
        alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okButton)
        alertController.title = title
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    private func showMessages() {
        let navController = UINavigationController.init(rootViewController: MessageViewController())
        
        UIApplication.topViewController()?.present(navController, animated: true, completion: nil)
    }
}
