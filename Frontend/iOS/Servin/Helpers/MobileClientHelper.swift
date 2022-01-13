//
//  MobileClientHelper.swift
//  Liveworks
//
//  Created by Munib Rahman on 2019-06-05.
//  Copyright © 2019 Voltic Labs. All rights reserved.
//

// Takes an awsmobileclient error and returns the specified message, that is human readable.

import Foundation
import AWSMobileClient

enum UserType {
    case worker
    case venue
    case unknown
}

class MobileClientHelper: NSObject {
    class func decipher(error: AWSMobileClientError) -> String {
        switch error {
        case .aliasExists(let message):
            return message
        case .codeDeliveryFailure(let message):
            return message
        case .codeMismatch(let message):
            return message
        case .expiredCode(let message):
            return message
        case .groupExists(let message):
            return message
        case .internalError(let message):
            return message
        case .invalidLambdaResponse(let message):
            return message
        case .invalidOAuthFlow(let message):
            return message
        case .invalidParameter(let message):
            return message
        case .invalidPassword(let message):
            return message
        case .invalidUserPoolConfiguration(let message):
            return message
        case .limitExceeded(let message):
            return message
        case .mfaMethodNotFound(let message):
            return message
        case .notAuthorized(let message):
            return message
        case .passwordResetRequired(let message):
            return message
        case .resourceNotFound(let message):
            return message
        case .scopeDoesNotExist(let message):
            return message
        case .softwareTokenMFANotFound(let message):
            return message
        case .tooManyFailedAttempts(let message):
            return message
        case .tooManyRequests(let message):
            return message
        case .unexpectedLambda(let message):
            return message
        case .userLambdaValidation(let message):
            return message
        case .userNotConfirmed(let message):
            return message
        case .userNotFound(let message):
            return message
        case .usernameExists(let message):
            return message
        case .unknown(let message):
            return message
        case .notSignedIn(let message):
            return message
        case .identityIdUnavailable(let message):
            return message
        case .guestAccessNotAllowed(let message):
            return message
        case .federationProviderExists(let message):
            return message
        case .cognitoIdentityPoolNotConfigured(let message):
            return message
        case .unableToSignIn(let message):
            return message
        case .invalidState(let message):
            return message
        case .userPoolNotConfigured(let message):
            return message
        case .userCancelledSignIn(let message):
            return message
        case .badRequest(let message):
            return message
        case .expiredRefreshToken(let message):
            return message
        case .errorLoadingPage(let message):
            return message
        case .securityFailed(let message):
            return message
        case .idTokenNotIssued(let message):
            return message
        case .idTokenAndAcceessTokenNotIssued(let message):
            return message
        case .invalidConfiguration(let message):
            return message
        case .deviceNotRemembered(let message):
            return message
        }
    }
    
    
    private override init() {
    }
    
    static let shared = MobileClientHelper()
    
    func determineUserType(onSuccess: @escaping (UserType) -> Void,
                           onError: @escaping (Error?) -> Void) {
        
        AWSMobileClient.sharedInstance().getUserAttributes { (result, error) in
            
            
            if let result = result {
                print(result)
                if result["custom:user_type"] == "venue" {
                    onSuccess(.venue)
                } else if result["custom:user_type"] == "worker" {
                    onSuccess(.worker)
                }
            } else if let error = error as? AWSMobileClientError {
                print(error)
                print(MobileClientHelper.decipher(error: error))
                onError(error)
            } else if let error = error {
                print(error)
                onError(error)
            }
        }
        
    }
    
    func getIPAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" || name == "pdp_ip0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
    
}
