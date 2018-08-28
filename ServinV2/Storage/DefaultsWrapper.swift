//
//  UserDefaults.swift
//  ServinV2
//
//  Created by Developer on 2018-08-20.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import Foundation
import UIKit

enum Key: String {
    case firstName
    case lastName
    case memberSince
    case school
    case imagePath
    case servinPoints
}

class DefaultsWrapper {
    
    
    
    class func getObject(_ key: Key) -> Any? {
        return UserDefaults.standard.object(forKey: key.rawValue)
    }

    class func getInt(_ key: Key) -> Int {
        return UserDefaults.standard.integer(forKey: key.rawValue)
    }
    
    class func getBool(_ key: Key) -> Bool {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
    
    class func getFloat(_ key: Key) -> Float {
        return UserDefaults.standard.float(forKey: key.rawValue)
    }
    
    class func getString(_ key: Key) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }
    
    class func getData(_ key: Key) -> Data? {
        return UserDefaults.standard.data(forKey: key.rawValue)
    }
    
    class func getArray(_ key: Key) -> [Any]? {
        return UserDefaults.standard.array(forKey: key.rawValue)
    }
    
    class func getDictionary(_ key: Key) -> [String : Any]? {
        return UserDefaults.standard.dictionary(forKey: key.rawValue)
    }
    
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Get value with default value
    //-------------------------------------------------------------------------------------------
    
    class func getObject(_ key: Key, defaultValue: Any) -> Any? {
        if getObject(key) == nil {
            return defaultValue
        }
        return getObject(key)
    }
    
    class func getInt(key: Key, defaultValue: Int) -> Int {
        if getObject(key) == nil {
            return defaultValue
        }
        return getInt(key)
    }
    
    class func getBool(key: Key, defaultValue: Bool) -> Bool {
        if getObject(key) == nil {
            return defaultValue
        }
        return getBool(key)
    }
    
    class func getFloat(key: Key, defaultValue: Float) -> Float {
        if getObject(key) == nil {
            return defaultValue
        }
        return getFloat(key)
    }
    
    class func getString(key: Key, defaultValue: String) -> String? {
        if getObject(key) == nil {
            return defaultValue
        }
        return getString(key)
    }
    
    class func getData(key: Key, defaultValue: Data) -> Data? {
        if getObject(key) == nil {
            return defaultValue
        }
        return getData(key)
    }
    
    class func getArray(key: Key, defaultValue: [Any]) -> [Any]? {
        if getObject(key) == nil {
            return defaultValue
        }
        return getArray(key)
    }
    
    class func getDictionary(key: Key, defaultValue: [String : Any]) -> [String : Any]? {
        if getObject(key) == nil {
            return defaultValue
        }
        return getDictionary(key)
    }
    
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Set value
    //-------------------------------------------------------------------------------------------
    
    class func setObject(_ key: Key, value: Any?) {
        if value == nil {
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        } else {
            UserDefaults.standard.set(value, forKey: key.rawValue)
        }
        syncUserDefaults()
    }
    
    class func setInt(key: Key, value: Int) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        syncUserDefaults()
    }
    
    class func setBool(key: Key, value: Bool) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        syncUserDefaults()
    }
    
    class func setFloat(key: Key, value: Float) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        syncUserDefaults()
    }
    
    class func setString(key: Key, value: String?) {
        if (value == nil) {
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        } else {
            UserDefaults.standard.set(value, forKey: key.rawValue)
        }
        syncUserDefaults()
    }
    
    class func setData(key: Key, value: NSData) {
        setObject(key, value: value)
    }
    
    class func setArray(key: Key, value: NSArray) {
        setObject(key, value: value)
    }
    
    
    class func setDictionary(key: Key, value: NSDictionary) {
        setObject(key, value: value)
    }
    
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Synchronize
    //-------------------------------------------------------------------------------------------
    
    class func syncUserDefaults() {
        UserDefaults.standard.synchronize()
    }
    
    class func save(image: UIImage, named: String) -> Bool {
        guard let data = UIImageJPEGRepresentation(image, 1) ?? UIImagePNGRepresentation(image) else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent(named)!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func getImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
}
