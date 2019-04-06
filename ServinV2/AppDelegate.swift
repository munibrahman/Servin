//
//  AppDelegate.swift
//  ServinV2
//
//  Created by Developer on 2018-04-14.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import GoogleMaps
import IQKeyboardManagerSwift
import PinpointKit
import Stripe
import AWSAppSync
import AWSCore
import AWSPinpoint
import UserNotifications

import AWSMobileClient



let userPoolID = "SampleUserPool"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    let AppSyncRegion: AWSRegionType = AWSRegionType.USEast1
    let AppSyncEndpointURL: URL = URL(string: "https://56hximzn65hwvcy7mgoksjdqoa.appsync-api.us-east-1.amazonaws.com/graphql")!
    let database_name: String = "local-appsync-db"
    let pinpointAppId: String = "128f6b300d75446f9c2ca0ffb248e4f7"
    
    var pinpoint: AWSPinpoint?

    var window: UIWindow?
    let googleMapsApiKey = Constants.googleMapsApiKey
    
    private static let pinpointKit = PinpointKit(feedbackRecipients: ["servin.feedback@gmail.com"])
    
    var loginViewController: LoginViewController?
    var navigationController: UINavigationController?
    
    var cognitoConfig: CognitoConfig?
    
    var storyboard: UIStoryboard? {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    var rememberDeviceCompletionSource: AWSTaskCompletionSource<NSNumber>?
    
    var appSyncClient: AWSAppSyncClient?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        ShortcutParser.shared.registerShortcuts()
        
        // Stripe Key
        STPPaymentConfiguration.shared().publishableKey = Constants.stripePublishableKey
        STPPaymentConfiguration.shared().appleMerchantIdentifier = Constants.appleMerchantIdentifier
        STPPaymentConfiguration.shared().companyName = "Servin"
        
        // Google Maps Key
        GMSServices.provideAPIKey(googleMapsApiKey)
        
        // Setup for IQKeyboardManagerSwift
        IQKeyboardManager.shared.enable = true
        // If you remove this, you start to see weird spacing between the text bar and the keyboard...
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(DetailedMessageViewController.self)
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        // setup logging
        AWSDDLog.sharedInstance.logLevel = .verbose
        //        AWSDDLog.add(AWSDDTTYLogger.sharedInstance)
        
        // setup cognito config
        self.cognitoConfig = CognitoConfig()
        
        // setup app sync, also inits the AWSMobileClient too
        initializeAppSync()
        
        
        
        let _ = ServinData.init()


        performReachabilityTest()
        
        

        // Start of setting up an identity pool for aws pinpoint
        
        let cognitoCredentialsProvider: AWSCognitoCredentialsProvider = AWSCognitoCredentialsProvider.init(regionType: AWSRegionType.USEast1, identityPoolId: "us-east-1:b0beefa4-2b4d-4e19-a1a7-8e01600d6e41"); //Override Your Region Here
        
        let serviceConfig: AWSServiceConfiguration = AWSServiceConfiguration.init(region: AWSRegionType.USEast1, credentialsProvider: cognitoCredentialsProvider)
        
        let config: AWSPinpointConfiguration = AWSPinpointConfiguration.init(appId: "128f6b300d75446f9c2ca0ffb248e4f7", launchOptions: launchOptions);
        
        
        
        config.serviceConfiguration = serviceConfig;
        config.targetingServiceConfiguration = serviceConfig;
        
        pinpoint = AWSPinpoint.init(configuration:config)
        
        
        
        
        // This must be the last call AFTER everything else has been setup, otherwise the user pool will be empty...
        showFirstViewController()
        
        return true
    }
    
    func initializeAppSync() {
        
        // Setup AWSMobileClient
        AWSMobileClient.sharedInstance().initialize { (userState, error) in
            if let userState = userState {
                print("UserState: \(userState.rawValue)")
                
            } else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
        
        
        
        // TODO: Change this to follow identity pools instead of userpools when actual identity pools are up.
        // ? : Can we actually use the identity pools in here or not?
        // https://aws-amplify.github.io/docs/ios/api#iam
        do {
            // You can choose the directory in which AppSync stores its persistent cache databases
            let cacheConfiguration = try AWSAppSyncCacheConfiguration()
            
            // Initialize the AWS AppSync configuration
            let appSyncConfig = try AWSAppSyncClientConfiguration(appSyncServiceConfig: AWSAppSyncServiceConfig(),
                                                                  userPoolsAuthProvider: {
                                                                    class MyCognitoUserPoolsAuthProvider : AWSCognitoUserPoolsAuthProviderAsync {
                                                                        func getLatestAuthToken(_ callback: @escaping (String?, Error?) -> Void) {
                                                                            AWSMobileClient.sharedInstance().getTokens { (tokens, error) in
                                                                                if error != nil {
                                                                                    callback(nil, error)
                                                                                } else {
                                                                                    callback(tokens?.idToken?.tokenString, nil)
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                    return MyCognitoUserPoolsAuthProvider()}(),
                                                                  cacheConfiguration: cacheConfiguration)
            
            // Initialize the AWS AppSync client
            appSyncClient = try AWSAppSyncClient(appSyncConfig: appSyncConfig)
            print("Initialized appsync client")
        } catch {
            print("Error initializing appsync client. \(error)")
        }
    }
    
    func showFirstViewController() {

        // Settings for PinpointKit, so that users can send bug requests, remove it once app is going live.
        self.window = ShakeDetectingWindow(frame: UIScreen.main.bounds, delegate: AppDelegate.pinpointKit)
        
//        let initialViewController = storyboard?.instantiateViewController(withIdentifier: String.init(describing: WelcomeViewController.self))
        
//        let initialViewController = UINavigationController.init(rootViewController: MessageViewController())
        
//        let initialViewController = CheckoutViewController.init(product: "Thing", price: 1000)
        self.window?.rootViewController = InitialViewController()
        self.window?.makeKeyAndVisible()
        
    }
    
    func performReachabilityTest() {
        do {
            Network.reachability = try Reachability(hostname: "www.google.com")
            do {
                try Network.reachability?.start()
            } catch let error as Network.Error {
                print(error)
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // Handle any deep links
        Deeplinker.checkDeepLink()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: Shortcuts
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(Deeplinker.handleShortcut(item: shortcutItem))
        
    }
    
    // MARK: Deep link
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return Deeplinker.handleDeeplink(url: url)
    }
    
    // MARK: Universal Links
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL {
                return Deeplinker.handleDeeplink(url: url)
            }
        }
        return false
    }
    
    // MARK: Notifications
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        pinpoint!.notificationManager.interceptDidRegisterForRemoteNotifications(
            withDeviceToken: deviceToken)
        print("Channel Type: \(pinpoint?.targetingClient.currentEndpointProfile())")
        print("Did register for remote notifs with device token \(deviceToken.base64EncodedString())")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifcations \(error.localizedDescription)")
    }
    
    // Request user to grant permissions for the app to use notifications
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            if let error = error {
                print("Error asking for permission: \(error)")
                return
            }
            print("Permission granted: \(granted)")
            // 1. Check if permission granted
            guard granted else { return }
            // 2. Attempt registration for remote notifications on the main thread
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("Got notification")
        pinpoint!.notificationManager.interceptDidReceiveRemoteNotification(
            userInfo, fetchCompletionHandler: completionHandler)
        
        if (application.applicationState == .active) {
            let alert = UIAlertController(title: "Notification Received",
                                          message: userInfo.description,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            UIApplication.shared.keyWindow?.rootViewController?.present(
                alert, animated: true, completion:nil)
        }
        
        Deeplinker.handleRemoteNotification(userInfo)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("recieved notification in foreground")
        // TODO: SHow a notification or something, look at how messenger does this
    }

}


