//
//  UIView+ShimmerSubviews.swift
//  Razz
//
//  Created by Alexander on 23.10.2020.
//  Copyright © 2020 Wildberries LLC. All rights reserved.
//

import UIKit

extension UIView {
    
    var shimmerableSubviews: [ShimmeringView] {
        var views = [ShimmeringView]()
        subviews.forEach { views.append(contentsOf: $0.shimmerableSubviews) }
        if let shimmerable = self as? ShimmeringView {
            views.append(shimmerable)
        }
        return views
    }
}
