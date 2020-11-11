//
//  UIView+FirstResponder.swift
//  Razz
//
//  Created by Alexander on 21.10.2020.
//  Copyright © 2020 Wildberries LLC. All rights reserved.
//

import UIKit

extension UIView {
    
    var firstResponder: UIView? {
        isFirstResponder ? self : subviews.first(where: { $0.firstResponder != nil })?.firstResponder ?? nil
    }
    
    var firstRespondable: [UIView] {
        var views = [UIView]()
        subviews.forEach { views.append(contentsOf: $0.firstRespondable) }
        if canBecomeFirstResponder, (self as? UITextView)?.isEditable != false, (self as? UITextField)?.isEnabled != false {
            views.append(self)
        }
        return views
    }
}
