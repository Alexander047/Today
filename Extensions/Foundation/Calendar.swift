//
//  Calendar.swift
//  Today
//
//  Created by Alexander on 30.11.2022.
//

import Foundation

extension Calendar {
    
    static let iso8601 = Calendar(identifier: .iso8601)
    
    static let iso8601UTC: Calendar = {
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()
    
    mutating func settingFirstWeekday(_ day: Int) -> Self {
        self.firstWeekday = day
        return self
    }
}
