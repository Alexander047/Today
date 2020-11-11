//
//  UICollectionView.swift
//  Razz
//
//  Created by Alexander on 06.11.2020.
//  Copyright © 2020 Wildberries LLC. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func isValidCell(byIndexPath indexPath: IndexPath) -> Bool {
        return indexPath.section < numberOfSections &&
            indexPath.row < numberOfItems(inSection: indexPath.section)
    }
    
    func cell(at location: CGPoint) -> UICollectionViewCell? {
        return visibleCells.first(where: { $0.frame.contains(location) })
    }
    
    func cell(under gesture: UIGestureRecognizer) -> UICollectionViewCell? {
        return cell(at: gesture.location(in: self))
    }
    
    func cellWidth(forColumnsCount columns: Int, spacing: CGFloat, sectionInsets: UIEdgeInsets = .zero) -> CGFloat {
        guard columns > 0 else { return .zero }
        
        let columnsSpacings = spacing * CGFloat(columns - 1)
        let availableWidth = (bounds.width - contentInset.horizontal - safeAreaInsets.horizontal) - columnsSpacings - sectionInsets.horizontal
        let cellWidth = floor(availableWidth / CGFloat(columns))
        
        return cellWidth
    }
    
    func validate(indexPath: IndexPath) -> Bool {
        if indexPath.section >= numberOfSections ||
            indexPath.row >= numberOfItems(inSection: indexPath.section) {
            return false
        }
        return true
    }
}

// MARK: Cells registration and dequeueing
extension UICollectionView {
    
    func register<T: UICollectionViewCell>(cellWithClass type: T.Type) {
        register(T.self, forCellWithReuseIdentifier: type.className)
    }
    
    func register<T: UICollectionViewCell>(nibWithCellClass type: T.Type) {
        register(UINib(nibName: type.className, bundle: Bundle.main), forCellWithReuseIdentifier: type.className)
    }
    
    func dequeueCell<T: UICollectionViewCell>(withClass type: T.Type,
                                              reuseIdentifier: String? = nil,
                                              for indexPath: IndexPath) -> T {
        let reuseIdentifier = reuseIdentifier ?? type.className
        guard let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? T else {
            fatalError("Couldn't find UICollectionViewCell for \(type.className)")
        }
        return cell
    }
}

// MARK: Supplementary Views registration and dequeueing
extension UICollectionView {
    enum SupplementaryType {
        case header
        case footer
        case custom(String)
        
        init(rawValue: String) {
            switch rawValue {
            case UICollectionView.elementKindSectionHeader: self = .header
            case UICollectionView.elementKindSectionFooter: self = .footer
            default: self = .custom(rawValue)
            }
        }
        
        var rawValue: String {
            switch self {
            case .header: return UICollectionView.elementKindSectionHeader
            case .footer: return UICollectionView.elementKindSectionFooter
            case .custom(let rawValue): return rawValue
            }
        }
    }
    
    func register<T: UICollectionReusableView>(supplementaryNibWithClass type: T.Type, OfKind kind: SupplementaryType) {
        register(UINib(nibName: type.className, bundle: Bundle.main),
                 forSupplementaryViewOfKind: kind.rawValue,
                 withReuseIdentifier: type.className)
    }
    
    func register<T: UICollectionReusableView>(supplementaryClass type: T.Type, OfKind kind: SupplementaryType) {
        register(T.self, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: type.className)
    }
    
    func dequeueSupplementaryView<T: UICollectionReusableView>(withClass type: T.Type,
                                                               ofKind kind: SupplementaryType,
                                                               at indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableSupplementaryView(ofKind: kind.rawValue,
                                                          withReuseIdentifier: type.className,
                                                          for: indexPath) as? T
            else {
                fatalError("Couldn't find UICollectionReusableView for \(type.className)")
        }
        return cell
    }
}
