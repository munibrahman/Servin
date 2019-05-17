//
//  PinpointManager.swift
//  ServinV2
//
//  Created by Munib Rahman on 2019-05-13.
//  Copyright © 2019 Voltic Labs Inc. All rights reserved.
//

import Foundation
import AWSMobileClient
import AWSPinpoint

class PinpointManager: NSObject {
    
    static let shared =  PinpointManager()
    
    public func sendPinpointNotification(to cognitoUser: String, title: String, body: String) {
        //                https://stackoverflow.com/questions/51576333/send-push-notification-from-ios-using-aws-pinpoint?rq=1
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let pinpoint = appDelegate.pinpoint  {
            
            print("Sending notification to cognito user: \(cognitoUser)")
            
            let getEndpointRequest = AWSPinpointTargetingGetUserEndpointsRequest()!
            getEndpointRequest.applicationId = pinpoint.configuration.appId
            getEndpointRequest.userId = cognitoUser
            
            
            AWSPinpointTargeting.default().getUserEndpoints(getEndpointRequest) { (response, error) in
                if let error = error {
                    print("Unable to retrieve the user's endpoint id")
                    print(error)
                    print(error.localizedDescription)
                }
                
                if let response = response {
                    print(response)
                    print(response.endpointsResponse)
                    print(response.endpointsResponse?.item)
                    
                    /*
                     
                     var par = {
                         ApplicationId: pinpointAppId, /* required */
                         MessageRequest: { /* required */
                             Endpoints: {
                             [userEndpoint]: {
                                 BodyOverride: content,
                                 TitleOverride: title
                             }
                             },
                             MessageConfiguration: {
                                 APNSMessage: {
                                     Action: 'OPEN_APP',
                                     TimeToLive: 3600,
                                 }
                             }
                         }
                     };
                     */
                    // https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/Pinpoint.html#sendMessages-property
                    // https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/PayloadKeyReference.html
                    
                    if let itemArray = response.endpointsResponse?.item {
                        for endpoint in itemArray {
                            if endpoint.channelType == .apns {
                                print("This is an apple device")
                                print("Endpoint Id \(endpoint.identifier)")
                                
                                let sendConfiguration = AWSPinpointTargetingEndpointSendConfiguration.init()!
                                sendConfiguration.bodyOverride = body
                                sendConfiguration.titleOverride = title
                                
                                let apnsMessage = AWSPinpointTargetingAPNSMessage.init()!
                                apnsMessage.action = AWSPinpointTargetingAction.openApp
                                apnsMessage.timeToLive = 3600
                                apnsMessage.sound = "default"
                                
                                
                                let messageConfig = AWSPinpointTargetingDirectMessageConfiguration.init()!
                                messageConfig.apnsMessage = apnsMessage
                                
                                let messageRequest = AWSPinpointTargetingMessageRequest.init()!
                                messageRequest.endpoints = [endpoint.identifier! : sendConfiguration]
                                messageRequest.messageConfiguration = messageConfig
                                
                                
                                let request = AWSPinpointTargetingSendMessagesRequest.init()!
                                request.applicationId = pinpoint.configuration.appId
                                request.messageRequest = messageRequest
                                
                                print("request")
                                print(request)
                                
                                AWSPinpointTargeting.default().sendMessages(request, completionHandler: { (res, error) in
                                    if let error = error {
                                        print("Error sending message to endpoint" )
                                        print(error)
                                        print(error.localizedDescription)
                                    }
                                    
                                    if let res = res {
                                        print(res.messageResponse?.endpointResult)
                                    }
                                })
                                
                            }
                        }
                        
                    }
                    
                    
                }
            }
            
            //            let sendMessagesRequest = AWSPinpointTargetingSendMessagesRequest()!
            //            sendMessagesRequest.applicationId = pinpoint.configuration.appId
            //            sendMessagesRequest.messageRequest = messageRequest
            //
            //            AWSPinpointTargeting.default().sendMessages(sendMessagesRequest){ response, error in
            //                ...
            //            }
            //            AWSPinpointTargeting.init().sendMessages(<#T##request: AWSPinpointTargetingSendMessagesRequest##AWSPinpointTargetingSendMessagesRequest#>)
            
        }
    }
    
    public func subscribeToPinpointNotifications() {
        if let myDelegate = UIApplication.shared.delegate as? AppDelegate {
            print("Asking to register for push notifications")
            myDelegate.registerForPushNotifications()
            
            
            if let targetingClient = myDelegate.pinpoint?.targetingClient {
                let endpoint = targetingClient.currentEndpointProfile()
                
                // Create a user and set its userId property
                let user = AWSPinpointEndpointProfileUser()
                user.userId = AWSMobileClient.sharedInstance().username
                // Assign the user to the endpoint
                endpoint.user = user
                endpoint.optOut = "NONE"
//                print("Channel type: \(endpoint.channelType)")
                // Update the endpoint with the targeting client
                
                targetingClient.update(endpoint).continueWith { (task) -> Any? in
                    if let err = task.error {
                        print("Error no \(err)");
                    } else {
                        print("Success yes \(task.result)")
                        print("Assigned user ID \(user.userId ?? "nil") to endpoint \(endpoint.endpointId)")
                    }
                    
                    print("Ran something")
                    
                    return nil
                }
                
                
                
            }
        }
    }
    
}
