//
//  UserDefaultsManager.swift
//  NetworkExtensions
//
//  Created by Henrik Peters on 31.12.19.
//  Copyright © 2019 Henrik Peters. All rights reserved.
//

import Foundation

// MARK: - UserDefaults Extension
extension UserDefaults {
    static var group: UserDefaults? {
        return UserDefaults(suiteName: Constants.appGroupIdentifier)!
    }
}

// MARK: - UserDefaultsManager
class UserDefaultsManager {
    // MARK: - UserDefaultsConstants
    static let keyPrefix = "sharedData_"
    
    //  MARK: - Public Routines :: Setter
    static func setSingleString(value v: String, forKey k: String) {
        NSLog(UserDefaults.group!.dictionaryRepresentation().description )
        //NSLog(FileManager().containerURL(forSecurityApplicationGroupIdentifier: "group.com.research.NetworkExtensions")!.appendingPathComponent("Library/Preferences").absoluteString)
        UserDefaults.group!.set(v, forKey: self.keyPrefix+k)
    }
    
    static func setStringArray(value v: [String], forKey k: String) {
        UserDefaults.group!.set(v, forKey: self.keyPrefix+k)
    }
    
    //  MARK: - Public Routines :: Getter
    static func getData(forKey k: String) -> Any? {
        if k.hasPrefix(self.keyPrefix) {
            return UserDefaults.group!.object(forKey: k)
        } else {
            return UserDefaults.group!.object(forKey: self.keyPrefix+k)
        }
    }
    
    static func getAllValues() -> Dictionary<String, Any>.Values {
        return (UserDefaults.group?.dictionaryRepresentation().values)!
    }
    
    static func getAllKeys() -> Dictionary<String, Any>.Keys {
        return (UserDefaults.group?.dictionaryRepresentation().keys)!
    }
    
    static func getAllData() -> Dictionary<String, Any> {
        return (UserDefaults.group?.dictionaryRepresentation())!
    }
}
