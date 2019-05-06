//
//  Extensions.swift
//  Servin
//
//  Created by Macbook on 2017-08-07.
//  Copyright © 2017 Macbook. All rights reserved.
//

import Foundation
import UIKit
import NotificationBannerSwift

extension Double
{
    func truncate(places : Int)-> Double
    {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}


// Allows for any view controller to show error, warning or success messages when something happens
extension UIViewController  {
    func showErrorNotification(title: String?, subtitle: String?) {
        DispatchQueue.main.async {
            let banner = NotificationBanner.init(title: title, subtitle: subtitle, leftView: nil, rightView: nil, style: BannerStyle.danger, colors: nil)
            banner.show()
        }
    }
    func showWarningNotification(title: String?, subtitle: String?) {
        DispatchQueue.main.async {
            let banner = NotificationBanner.init(title: title, subtitle: subtitle, leftView: nil, rightView: nil, style: BannerStyle.warning, colors: nil)
            banner.show()
        }
    }
    func showSuccessNotification(title: String?, subtitle: String?) {
        DispatchQueue.main.async {
            let banner = NotificationBanner.init(title: title, subtitle: subtitle, leftView: nil, rightView: nil, style: BannerStyle.success, colors: nil)
            banner.show()
        }
    }
}


// To dismiss the keyboard when anywhere else is tapped.
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

@IBDesignable extension UIView {
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}



extension UIButton {
    
    /// Add image on left view
    func leftImage(image: UIImage) {
        self.setImage(image, for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: image.size.width)
    }
}



extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
        
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBarForSegmentControl(color: UIColor, width: CGFloat, spacing: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0 + spacing, y: self.frame.size.height - width, width: self.frame.size.width - (spacing * 2), height: width)
        self.layer.addSublayer(border)
        
    }
    
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}


extension UIColor {
    
    open class var blackFontColor: UIColor {
        return UIColor.init(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
    }
    
    open class var greyBackgroundColor: UIColor {
        return UIColor.init(red: 57.0/255.0, green: 55.0/255.0, blue: 68.0/255.0, alpha: 1.0)
    }
    
    open class var shockingPinkColor: UIColor {
        return UIColor.init(red: 255.0/255.0, green: 51.0/255.0, blue: 102.0/255.0, alpha: 1.0)
    }
    
    open class var emptyStateBackgroundColor: UIColor {
        return UIColor.init(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1.0)
    }
    
    open class var navigationProgressColor: UIColor {
        return UIColor.white
    }
    
    open class var contentDivider: UIColor {
        return UIColor.init(red: 200.0/255.0, green: 199.0/255.0, blue: 204.0/255.0, alpha: 1.0)
    }
    
    open class var placeHolderColor: UIColor {
        return UIColor.init(red: 199.0/255.0, green: 199.0/255.0, blue: 205.0/255.0, alpha: 1.0)
    }
    
}

extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
}

extension UIViewController {
    
    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */
    
    var topbarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
}


extension UINavigationBar {
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
    
    func removeTransparentNavigationBar() {
        self.setBackgroundImage(nil, for: .default)
        self.shadowImage = UINavigationBar().shadowImage
        self.isTranslucent = false
    }
    
}


func getRandomColor() -> UIColor{
    //Generate between 0 to 1
    let red:CGFloat = CGFloat(drand48())
    let green:CGFloat = CGFloat(drand48())
    let blue:CGFloat = CGFloat(drand48())
    
    return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
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

extension UIViewController {
    
    func subscribeToNetworkChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        updateUserInterface()
    }
    
    @objc func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            view.backgroundColor = .red
        case .wifi:
            view.backgroundColor = .green
        case .wwan:
            view.backgroundColor = .yellow
        }
        print("Reachability Summary")
        print("Status:", status)
        print("HostName:", Network.reachability?.hostname ?? "nil")
        print("Reachable:", Network.reachability?.isReachable ?? "nil")
        print("Wifi:", Network.reachability?.isReachableViaWiFi ?? "nil")
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }

}


extension UIViewController {
    /// Validate email string
    ///
    /// - parameter email: A String that rappresent an email address
    ///
    /// - returns: A Boolean value indicating whether an email is valid.
    // https://www.iostutorialjunction.com/2018/01/email-address-validation-in-swift-beginners-tutorial-for-swift-learners.html
    func isValidEmail(emailID:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }
}

class Extensions: NSObject {
    static func getReadableDate(timeStamp: TimeInterval) -> String? {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        
        if Calendar.current.isDateInTomorrow(date) {
            return "Tomorrow"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else if dateFallsInCurrentWeek(date: date) {
            if Calendar.current.isDateInToday(date) {
                dateFormatter.dateFormat = "h:mm a"
                return dateFormatter.string(from: date)
            } else {
                dateFormatter.dateFormat = "EEEE"
                return dateFormatter.string(from: date)
            }
        } else {
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: date)
        }
    }
    
    static func dateFallsInCurrentWeek(date: Date) -> Bool {
        let currentWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: Date())
        let datesWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: date)
        return (currentWeek == datesWeek)
    }
}



extension Date {
    func monthAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMM")
        return df.string(from: self)
    }
    
    func dayAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("dd")
        return df.string(from: self)
    }
    
    func yearAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("YYYY")
        return df.string(from: self)
    }
    
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    
    func timeAsAMPM() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: self)
    }
    
    func asAWSTIME() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    func asAWSDATE() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
}




//https://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings
extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

let imageCache = NSCache<AnyObject, AnyObject>.init()

extension UIImageView {
    func loadImageUsingS3Key(key: String) {
        
//        image = nil
        
        S3Manager.default().downloadImage(bucket: nil, key: key, expression: nil, onSuccess: { (image) in
            
            DispatchQueue.main.async {
                
                if let imageFromCache = imageCache.object(forKey: key as AnyObject) as? UIImage {
                    print("Found image in cache")
                    self.image = imageFromCache
                    return
                }
                
                let imageToCache = image
                imageCache.setObject(imageToCache, forKey: key as AnyObject)
                self.image = imageToCache
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.image = #imageLiteral(resourceName: "default_image_icon")
                print("Error Fetching image for key: \(key)")
                print(error)
            }
        }
    }
}

import SwiftyJSON

extension String {
    func ICONImageKeyS3() -> String? {
        if let data = self.data(using: .utf8, allowLossyConversion: false) {
            do {
                let json = try JSON.init(data: data, options: JSONSerialization.ReadingOptions.allowFragments)
                return json["ICON"].stringValue
            } catch {
                print("Error getting ICON Image value \(error)")
            }
        }
        return nil
    }
    
    func MEDImageKeyS3() -> String? {
        if let data = self.data(using: .utf8, allowLossyConversion: false) {
            do {
                let json = try JSON.init(data: data, options: JSONSerialization.ReadingOptions.allowFragments)
                return json["MED"].stringValue
            } catch {
                print("Error getting MED Image value \(error)")
            }
        }
        
        return nil
    }
    
    func MAXImageKeyS3() -> String? {
        if let data = self.data(using: .utf8, allowLossyConversion: false) {
            do {
                let json = try JSON.init(data: data, options: JSONSerialization.ReadingOptions.allowFragments)
                return json["MAX"].stringValue
            } catch {
                print("Error getting MAX Image value \(error)")
            }
        }
        
        return nil
    }
    
    func originalImageKeyS3() -> String? {
        if let data = self.data(using: .utf8, allowLossyConversion: false) {
            do {
                let json = try JSON.init(data: data, options: JSONSerialization.ReadingOptions.allowFragments)
                return json["original"].stringValue
            } catch {
                print("Error getting original Image value \(error)")
            }
        }
        
        return nil
    }
}

import NVActivityIndicatorView

extension UIViewController {
    func showServinLogoProgressView() {
        DispatchQueue.main.async {
            let backgroundView = UIView.init()
            backgroundView.backgroundColor = UIColor.greyBackgroundColor
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            backgroundView.tag = 80085
            self.view.addSubview(backgroundView)
            
            backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            
            let servinLogo = UIImageView.init()
            servinLogo.image = UIImage.init(named: "login_logo_servin")
            servinLogo.contentMode = .scaleAspectFit
            servinLogo.translatesAutoresizingMaskIntoConstraints = false
            
            backgroundView.addSubview(servinLogo)
            servinLogo.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
            servinLogo.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
            servinLogo.widthAnchor.constraint(equalToConstant: 116).isActive = true
            servinLogo.heightAnchor.constraint(equalToConstant: 210).isActive = true
            
            let loadingView = NVActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50), type: NVActivityIndicatorType.ballPulse, color: UIColor.white, padding: nil)
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            
            backgroundView.addSubview(loadingView)
            loadingView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
            loadingView.bottomAnchor.constraint(equalTo: backgroundView.layoutMarginsGuide.bottomAnchor, constant: -30).isActive = true
            loadingView.startAnimating()
        }
    }
    
    func hideServinLogoProgressView() {
        DispatchQueue.main.async {
            if let viewWithTag = self.view.viewWithTag(80085) {
                print("Tag 80085")
                viewWithTag.removeFromSuperview()
            } else {
                print("tag not found")
            }
        }
    }
}










