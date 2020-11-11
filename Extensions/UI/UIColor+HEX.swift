//
//  UIColor+HEX.swift
//  Razz
//
//  Created by Alexander on 15.10.2020.
//  Copyright © 2020 Wildberries LLC. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex: Int32, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
