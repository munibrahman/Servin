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
import AWSCognitoIdentityProvider
import Stripe
import AWSAppSync
import AWSCore
import AWSPinpoint
import UserNotifications
import AWSMobileClient
import AWSCognito


let userPoolID = "SampleUserPool"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    let AppSyncRegion: AWSRegionType = AWSRegionType.USEast1
    let AppSyncEndpointURL: URL = URL(string: "https://pn2eszmr25f3bgg4hdypm7gijy.appsync-api.us-east-1.amazonaws.com/graphql")!
    let database_name: String = "local-appsync-db"
    let pinpointAppId: String = "128f6b300d75446f9c2ca0ffb248e4f7"
    
    var pinpoint: AWSPinpoint?
    
    class func defaultUserPool() -> AWSCognitoIdentityUserPool {
        return AWSCognitoIdentityUserPool(forKey: userPoolID)
    }
    

    var window: UIWindow?
    let googleMapsApiKey = Constants.googleMapsApiKey
    
    private static let pinpointKit = PinpointKit(feedbackRecipients: ["servin.feedback@gmail.com"])
    
    var loginViewController: LoginViewController?
    var navigationController: UINavigationController?
    var mfaViewController: MFAViewController?
    var softwaremfaViewController: SoftwareMFAViewController?
    
    var cognitoConfig: CognitoConfig?
    
    var storyboard: UIStoryboard? {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    var rememberDeviceCompletionSource: AWSTaskCompletionSource<NSNumber>?
    
    var appSyncClient: AWSAppSyncClient?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
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
        
        // setup cognito
        setupCognitoUserPool()
        
        // setup app sync
        initializeAppSync()
        
        
        
        let _ = ServinData.init()
        // This must be the last call AFTER everything else has been setup, otherwise the user pool will be empty...
        showFirstViewController()

        performReachabilityTest()
        
        
        // Initialize Pinpoint
        /** start code copy **/

        let pp = AWSPinpointConfiguration.init(appId: pinpointAppId, launchOptions: launchOptions)
        pinpoint = AWSPinpoint(configuration: pp)
        
        
        
        // Create AWSMobileClient to connect with AWS
//        return AWSMobileClient.sharedInstance().interceptApplication(application, didFinishLaunchingWithOptions: launchOptions)
        /** end code copy **/
        
        return true
    }
    
    func setupCognitoUserPool() {
        
        print("Did setup cognito pool inside AppDelegate")
        
        let clientId:String = self.cognitoConfig!.getClientId()
        let poolId:String = self.cognitoConfig!.getPoolId()
        let clientSecret:String = self.cognitoConfig!.getClientSecret()
        let region:AWSRegionType = self.cognitoConfig!.getRegion()
        
        
        
        let serviceConfiguration:AWSServiceConfiguration = AWSServiceConfiguration(region: region, credentialsProvider: nil)
        let cognitoConfiguration:AWSCognitoIdentityUserPoolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: clientId, clientSecret: clientSecret, poolId: poolId)
        
//        let cognitoConfiguration:AWSCognitoIdentityUserPoolConfiguration = AWSCognitoIdentityUserPoolConfiguration.init(clientId: clientId, clientSecret: clientSecret, poolId: poolId, shouldProvideCognitoValidationData: true, pinpointAppId: pinpointAppId)
        
        AWSCognitoIdentityUserPool.register(with: serviceConfiguration, userPoolConfiguration: cognitoConfiguration, forKey: userPoolID)
        let pool:AWSCognitoIdentityUserPool = AppDelegate.defaultUserPool()
        pool.delegate = self
        
        AWSServiceManager.default().defaultServiceConfiguration = serviceConfiguration
    }
    
    func initializeAppSync() {
        // You can choose your database location, accessible by the SDK
        let databaseURL = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent("todos_db")
        
        do {
            // Initialize the AWS AppSync configuration
            let appSyncConfig = try AWSAppSyncClientConfiguration(appSyncClientInfo: AWSAppSyncClientInfo(),
                                                                  userPoolsAuthProvider: {
                                                                    class MyCognitoUserPoolsAuthProvider : AWSCognitoUserPoolsAuthProviderAsync {
                                                                        func getLatestAuthToken(_ callback: @escaping (String?, Error?) -> Void) {
                                                                           
                                                                            callback(KeyChainStore.shared.fetchIdToken() ?? "", nil)
                                                                        }
                                                                    }
                                                                    return MyCognitoUserPoolsAuthProvider()}(),
                                                                  databaseURL:databaseURL)
            
            // Initialize the AWS AppSync client
            appSyncClient = try AWSAppSyncClient(appSyncConfig: appSyncConfig)
            
        } catch {
            print("Error initializing appsync client. \(error)")
        }
    }
    
    func showFirstViewController() {

        // Settings for PinpointKit
        self.window = ShakeDetectingWindow(frame: UIScreen.main.bounds, delegate: AppDelegate.pinpointKit)
        
        let initialViewController = storyboard?.instantiateViewController(withIdentifier: String.init(describing: WelcomeViewController.self))
        
//        let initialViewController = UINavigationController.init(rootViewController: MessageViewController())
        
//        let initialViewController = CheckoutViewController.init(product: "Thing", price: 1000)
        self.window?.rootViewController = initialViewController
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
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return Deeplinker.handleDeeplink(url: url)
    }
    
    // MARK: Universal Links
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
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
    }

}

// MARK:- AWSCognitoIdentityInteractiveAuthenticationDelegate protocol delegate

// This function handles presenting the UI for Signing in.
extension AppDelegate: AWSCognitoIdentityInteractiveAuthenticationDelegate {
    
    
    func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {
        
        print("startPasswordAuthentication")
        
        if (self.navigationController == nil) {
            
            self.loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
            self.navigationController = UINavigationController.init(rootViewController: loginViewController!)
        }
        
        // This is where you present the login controller
        DispatchQueue.main.async {
            
            if (!self.navigationController!.isViewLoaded
                || self.navigationController!.view.window == nil) {
                UIApplication.topViewController()?.present(self.navigationController!, animated: true, completion: nil)
            }
            
        }
        return self.loginViewController!
    }
    
    func startSoftwareMfaSetupRequired() -> AWSCognitoIdentitySoftwareMfaSetupRequired {
        
        if softwaremfaViewController == nil {
            softwaremfaViewController = SoftwareMFAViewController()
        }
        
        
        DispatchQueue.main.async {
            
            
            if (!self.softwaremfaViewController!.isViewLoaded || self.softwaremfaViewController!.view.window == nil) {
                //display mfa as popover on current view controller
                
                let viewController = UIApplication.topViewController()
                viewController?.present(self.softwaremfaViewController!,
                                        animated: true,
                                        completion: nil)
                
                // configure popover vc
                let presentationController = self.softwaremfaViewController!.popoverPresentationController
                presentationController?.permittedArrowDirections = UIPopoverArrowDirection.left
                presentationController?.sourceView = viewController!.view
                presentationController?.sourceRect = viewController!.view.bounds
            }
            
        }
        
        return softwaremfaViewController!
        
    }
    
    func startMultiFactorAuthentication() -> AWSCognitoIdentityMultiFactorAuthentication {
        if (self.mfaViewController == nil) {
            self.mfaViewController = MFAViewController()
            self.mfaViewController?.modalPresentationStyle = .popover
        }
        DispatchQueue.main.async {
            if (!self.mfaViewController!.isViewLoaded
                || self.mfaViewController!.view.window == nil) {
                //display mfa as popover on current view controller
                let viewController = self.window?.rootViewController!
                viewController?.present(self.mfaViewController!,
                                        animated: true,
                                        completion: nil)
                
                // configure popover vc
                let presentationController = self.mfaViewController!.popoverPresentationController
                presentationController?.permittedArrowDirections = UIPopoverArrowDirection.left
                presentationController?.sourceView = viewController!.view
                presentationController?.sourceRect = viewController!.view.bounds
            }
        }
        return self.mfaViewController!
    }

    
    func startRememberDevice() -> AWSCognitoIdentityRememberDevice {
        return self
    }
}

// MARK:- AWSCognitoIdentityRememberDevice protocol delegate

extension AppDelegate: AWSCognitoIdentityRememberDevice {
    
    func getRememberDevice(_ rememberDeviceCompletionSource: AWSTaskCompletionSource<NSNumber>) {
        self.rememberDeviceCompletionSource = rememberDeviceCompletionSource
        DispatchQueue.main.async {
            // dismiss the view controller being present before asking to remember device
            self.window?.rootViewController!.presentedViewController?.dismiss(animated: true, completion: nil)
            let alertController = UIAlertController(title: "Remember Device",
                                                    message: "Do you want to remember this device?.",
                                                    preferredStyle: .actionSheet)
            
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                self.rememberDeviceCompletionSource?.set(result: true)
            })
            let noAction = UIAlertAction(title: "No", style: .default, handler: { (action) in
                self.rememberDeviceCompletionSource?.set(result: false)
            })
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            
            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func didCompleteStepWithError(_ error: Error?) {
        DispatchQueue.main.async {
            if let error = error as NSError? {
                let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                        message: error.userInfo["message"] as? String,
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                DispatchQueue.main.async {
                    self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}


