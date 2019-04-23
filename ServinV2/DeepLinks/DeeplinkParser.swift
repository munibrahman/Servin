//
//  DeeplinkParser.swift
//  Deeplinks
//
//  Created by Stanislav Ostrovskiy on 5/25/17.
//  Copyright © 2017 Stanislav Ostrovskiy. All rights reserved.
//

import Foundation

class DeeplinkParser {
    static let shared = DeeplinkParser()
    private init() { }
    
    func parseDeepLink(_ url: URL) -> DeeplinkType? {
        print("Deeplink URL")
        print(url)
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true), let host = components.host else {
            return nil
        }
        
        var pathComponents = components.path.components(separatedBy: "/")
        
        print("HOST \(host)")
        print("Path \(pathComponents)")

        // the first component is empty
        pathComponents.removeFirst()
        
        switch host {
        case "messages":
            if let messageId = pathComponents.first {
                return DeeplinkType.messages(.details(id: messageId))
            }
        case "confirm":
            print(pathComponents)
            if let username = pathComponents.first {
                let code = "test"
                
                print("username \(username)")
                print("code \(code)")
                return DeeplinkType.confirm(username: username, code: code)
            }
//https://www.servin.io/confirm/6280ec02-2756-463a-ac60-c041cd2c52f2/495241
        case "www.servin.io":
            print(pathComponents)
            pathComponents.removeFirst() // removes "confirm"
            if let username = pathComponents.first, let code = pathComponents[safe: 1] {
                
                print("username \(username)")
                print("code \(code)")
                return DeeplinkType.confirm(username: username, code: code)
            }
//        case "request":
//            if let requestId = pathComponents.first {
//                return DeeplinkType.request(id: requestId)
//            }
        default:
            break
        }
        return nil
    }
}
