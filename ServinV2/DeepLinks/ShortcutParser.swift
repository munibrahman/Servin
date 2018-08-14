//
//  ShortcutParser.swift
//  Deeplinks
//
//  Created by Stanislav Ostrovskiy on 5/25/17.
//  Copyright © 2017 Stanislav Ostrovskiy. All rights reserved.
//

import Foundation
import UIKit

enum ShortcutKey: String {
    case dropPin = "com.volticlabs.servin.dropPin"
    case messages = "com.volticlabs.servin.messages"
}

class ShortcutParser {
    static let shared = ShortcutParser()
    private init() { }
    
    func registerShortcuts() {
        
        let messageIcon = UIApplicationShortcutIcon(templateImageName: "Messenger Icon")
        let messageShortcutItem = UIApplicationShortcutItem(type: ShortcutKey.messages.rawValue, localizedTitle: "Messages", localizedSubtitle: nil, icon: messageIcon, userInfo: nil)
        
        let pinIcon = UIApplicationShortcutIcon.init(type: .markLocation)
        let pinShortcutItem = UIApplicationShortcutItem.init(type: ShortcutKey.dropPin.rawValue, localizedTitle: "Drop a pin", localizedSubtitle: nil, icon: pinIcon, userInfo: nil)
        
        
        UIApplication.shared.shortcutItems = [messageShortcutItem, pinShortcutItem]
        
//        switch profileType {
//        case .host:
//            let newListingIcon = UIApplicationShortcutIcon(templateImageName: "New Listing Icon")
//            let newListingShortcutItem = UIApplicationShortcutItem(type: ShortcutKey.newListing.rawValue, localizedTitle: "New Listing", localizedSubtitle: nil, icon: newListingIcon, userInfo: nil)
//            UIApplication.shared.shortcutItems?.append(newListingShortcutItem)
//        case .guest:
//            break
//        }
    }

    func handleShortcut(_ shortcut: UIApplicationShortcutItem) -> DeeplinkType? {
        switch shortcut.type {
        case ShortcutKey.dropPin.rawValue:
            return  DeeplinkType.dropNewPin
        case ShortcutKey.messages.rawValue:
            return  .messages(.root)
        default:
            return nil
        }
    }
}
