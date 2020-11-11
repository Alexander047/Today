//
//  UIFont+StaticFonts.swift
//  Razz
//
//  Created by Alexander Sheludchenko on 12.03.2020.
//  Copyright © 2020 Wildberries LLC. All rights reserved.
//

import UIKit

extension UIFont {
    
    /// Regular 17
    static let primary = UIFont.systemFont(ofSize: 17, weight: .regular)
    
    /// Bold 20
    static let button = UIFont.systemFont(ofSize: 20, weight: .bold)
    
    /// Regular 20
    static let dateEmpty = UIFont.systemFont(ofSize: 20, weight: .regular)
    
    /// Semibold 20
    static let dateFilled = UIFont.systemFont(ofSize: 20, weight: .semibold)
    
    /// Bold 20
    static let dateToday = UIFont.systemFont(ofSize: 20, weight: .bold)
    
    /// Bold  20
    static let subtitle = UIFont.systemFont(ofSize: 20, weight: .bold)
    
    /// Heavy 34
    static let title = UIFont.systemFont(ofSize: 34, weight: .heavy)
}

