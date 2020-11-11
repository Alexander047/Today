//
//  Collection.swift
//  Razz
//
//  Created by Alexander on 20.04.2020.
//  Copyright © 2020 Wildberries LLC. All rights reserved.
//

import Foundation

extension Collection where Element == URLQueryItem {
    
    var dictionaryValue: [String: String]? {
        Dictionary(uniqueKeysWithValues: map{ ($0.name, $0.value) }) as? [String: String]
    }
}

extension Collection where Element: AnyObject {
    
    func first<T>(ofType: T.Type) -> T? {
        return first(where: { $0 is T }) as? T
    }
}

extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
