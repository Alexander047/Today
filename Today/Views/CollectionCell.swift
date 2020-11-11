//
//  CollectionCell.swift
//  Razz
//
//  Created by Alexander on 06.11.2020.
//  Copyright © 2020 Wildberries LLC. All rights reserved.
//

import UIKit

final class CollectionCell<T: UIView>: UICollectionViewCell {
    
    var contentInset: UIEdgeInsets = .zero {
        didSet { setInsets(contentInset, for: sideConstraints) }
    }
    private(set) var view: T!
    private var sideConstraints: SideConstraints!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        view = T()
        sideConstraints = contentView.addSubviewWithConstraints(view)
    }
}

extension CollectionCell {
    
    static func parentForView<T: UIView>(_ view: T) -> CollectionCell<T>? {
        let contentView = view.superview
        let cell = contentView?.superview
        return cell as? CollectionCell<T>
    }
}
