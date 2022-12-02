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
    
    var dateComponents: DateComponents {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)
        return DateComponents(day: day, month: month, year: year)
    }
}

extension Date {
    struct DateComponents: Hashable, Comparable {
        static func < (lhs: Date.DateComponents, rhs: Date.DateComponents) -> Bool {
            return (lhs.year < rhs.year)
            || (lhs.year == rhs.year && lhs.month < rhs.month)
            || (lhs.year == rhs.year && lhs.month == rhs.month && lhs.day < rhs.day)
        }
        
        let day: Int
        let month: Int
        let year: Int
        
        func date() -> Date {
            let dateString = "\(day).\(month).\(year)"
            return DateFormatter.dateByDots.date(from: dateString)?.noon ?? Date().noon
        }
    }
}
