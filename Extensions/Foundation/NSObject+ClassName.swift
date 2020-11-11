//
//  NSObject+ClassName.swift
//  Razz
//
//  Created by Alexander Sheludchenko on 16.03.2020.
//  Copyright © 2020 Wildberries LLC. All rights reserved.
//

import Foundation

extension NSObject {
    
    public static var className: String {
        return String(describing: self)
    }
    
    public var className: String {
        return type(of: self).className
    }
}
