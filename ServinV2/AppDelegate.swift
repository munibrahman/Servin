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

let userPoolID = "SampleUserPool"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    class func defaultUserPool() -> AWSCognitoIdentityUserPool {
        return AWSCognitoIdentityUserPool(forKey: userPoolID)
    }
    

    var window: UIWindow?
    let googleMapsApiKey = "AIzaSyAGFQhWxsHh3UpGzvoTzB4flwsV_eCYODk"
    
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
    
    private let stripePublishableKey = "pk_test_eLAT9Nvbd7M9F3hnNX2EWO4k"
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        ShortcutParser.shared.registerShortcuts()
        
        // Stripe Key
        STPPaymentConfiguration.shared().publishableKey = self.stripePublishableKey
        STPPaymentConfiguration.shared().appleMerchantIdentifier = "merchant.com.servin"
        STPPaymentConfiguration.shared().companyName = "Servin"
        
        // Google Maps Key
        GMSServices.provideAPIKey(googleMapsApiKey)
        
        // Setup for IQKeyboardManagerSwift
        IQKeyboardManager.shared.enable = true
        
        
        // setup logging
        AWSDDLog.sharedInstance.logLevel = .verbose
        //        AWSDDLog.add(AWSDDTTYLogger.sharedInstance)
        
        // setup cognito config
        self.cognitoConfig = CognitoConfig()
        
        // setup cognito
        setupCognitoUserPool()
        
        let data = Data.init()
        // This must be the last call AFTER everything else has been setup, otherwise the user pool will be empty...
        showFirstViewController()

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
        AWSCognitoIdentityUserPool.register(with: serviceConfiguration, userPoolConfiguration: cognitoConfiguration, forKey: userPoolID)
        let pool:AWSCognitoIdentityUserPool = AppDelegate.defaultUserPool()
        pool.delegate = self
    }
    
    func showFirstViewController() {
        // NOTE: This MUST BE
        //        #if DEBUG
        // show whichever storbyboard you want to
        
        //        #else
        // show the beginning storyboard only
        // Settings for PinpointKit
        self.window = ShakeDetectingWindow(frame: UIScreen.main.bounds, delegate: AppDelegate.pinpointKit)
        
        
        let initialViewController = storyboard?.instantiateViewController(withIdentifier: String.init(describing: WelcomeViewController.self))
        
//        let initialViewController = UINavigationController.init(rootViewController: IdentificationRequestViewController())
        
        
        //let initialViewController = InitialViewController()
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        
        //        #endif
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
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Deeplinker.handleRemoteNotification(userInfo)
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

//MARK: - UIApplication Extension
extension UIApplication {
    class func topViewController(viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(viewController: nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(viewController: selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(viewController: presented)
        }
        return viewController
    }
}
