//
//  DateFormatter.swift
//  Razz
//
//  Created by Alexander on 17.04.2020.
//  Copyright © 2020 Wildberries LLC. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static let pickupReviewDate = DateFormatter.formatter(with: "dd MMMM yyyy")
    static let dateByDots = DateFormatter.formatter(with: "dd.MM.yyyy")
    static let time = DateFormatter.formatter(with: "HH:mm")
    
    static let transactionServer = DateFormatter.formatter(with: "yyyy-MM-dd'T'HH:mm:ss")
    static let transactionsInterval = DateFormatter.formatterUTC(with: "yyyy-MM-dd")
    static let transactionsFancyDate = DateFormatter.formatterUTC(with: "d MMMM, EEEE")
    static let transactionDetailDateTime = DateFormatter.formatter(with: "dd MMMM yyyy, HH:mm")
    
    static let productIssueBirthDate = DateFormatter.formatter(with: "yyyy-MM-dd")
    
    static func formatter(with dateFormat: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter
    }
    
    static func formatterUTC(with dateFormat: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = dateFormat
        return formatter
    }
}
