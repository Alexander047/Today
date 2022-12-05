//
//  GroupDefaults.swift
//  Today
//
//  Created by Alexander on 05.12.2022.
//

import Foundation

struct SharedDefaults {
    
    #if DEBUG
    private static let groupName = "group.com.SealSoft.Today-App.debug"
    #else
    private static let groupName = "group.com.SealSoft.Today-App"
    #endif
    
    private static let userDefaults = UserDefaults(suiteName: groupName)
    
    static func set(_ value: Any?, forKey key: String) {
        userDefaults?.set(value, forKey: key)
    }
    
    static func stringArray(forKey key: String) -> [String]? {
        userDefaults?.stringArray(forKey: key)
    }
}

