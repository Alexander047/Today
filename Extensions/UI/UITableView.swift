//
//  UITableView.swift
//  Razz
//
//  Created by Alexander on 20.04.2020.
//  Copyright © 2020 Wildberries LLC. All rights reserved.
//

import UIKit

// MARK: Cells registration and dequeueing
extension UITableView {
    
    func register<T: UITableViewCell>(cellWithClass type: T.Type) {
        register(T.self, forCellReuseIdentifier: type.className)
    }
    
    func register<T: UITableViewCell>(nibWithCellClass type: T.Type) {
        register(UINib(nibName: type.className, bundle: Bundle.main), forCellReuseIdentifier: type.className)
    }
    
    func register<T: UITableViewHeaderFooterView>(nibWithHeaderFooterClass type: T.Type) {
        register(UINib(nibName: type.className, bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: type.className)
    }
    
    func register<T: UITableViewHeaderFooterView>(headerFooterWithClass type: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: type.className)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(withClass type: T.Type,
                                                 reuseIdentifier: String? = nil,
                                                 for indexPath: IndexPath) -> T {
        let reuseIdentifier = reuseIdentifier ?? type.className
        guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T else {
            fatalError("Couldn't find UITableViewCell for \(type.className)")
        }
        return cell
    }
    
    func dequeueReusableCell<T: UITableViewCell>(withClass type: T.Type, reuseIdentifier: String? = nil) -> T {
        let reuseIdentifier = reuseIdentifier ?? type.className
        guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier) as? T else {
            fatalError("Couldn't find UITableViewCell for \(type.className)")
        }
        return cell
    }
    
    func dequeueReusableHeaderFooter<T: UITableViewHeaderFooterView>(withClass type: T.Type) -> T {
        guard let headerFooter = dequeueReusableHeaderFooterView(withIdentifier: type.className) as? T else {
            fatalError("Couldn't find UITableViewHeaderFooterView for \(type.className)")
        }
        return headerFooter
    }
}
