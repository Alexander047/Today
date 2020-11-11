//
//  Date.swift
//  Razz
//
//  Created by Alexander Sheludchenko on 16.09.2020.
//  Copyright © 2020 Wildberries LLC. All rights reserved.
//

import Foundation

extension Date {
    
    static var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date().noon) ?? Date()
    }
    
    var dayStart: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self) ?? Date()
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self) ?? Date()
    }
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self) ?? Date()
    }
}
