//
//  UIEdgeInsets+HV.swift
//  Razz
//
//  Created by Alexander Sheludchenko on 12.03.2020.
//  Copyright © 2020 Wildberries LLC. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    
    var horizontal: CGFloat { left + right }
    
    var vertical: CGFloat { top + bottom }
}
