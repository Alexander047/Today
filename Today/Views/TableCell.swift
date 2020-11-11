//
//  TableCell.swift
//  Razz
//
//  Created by Alexander on 20.04.2020.
//  Copyright © 2020 Wildberries LLC. All rights reserved.
//

import UIKit

final class TableCell<T: UIView>: UITableViewCell {
    
    var contentInset: UIEdgeInsets = .zero {
        didSet { setInsets(contentInset, for: sideConstraints) }
    }
    private(set) var view: T!
    private var sideConstraints: SideConstraints!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        view = T()
        sideConstraints = contentView.addSubviewWithConstraints(view)
    }
}

extension TableCell {
    
    static func parentForView<T: UIView>(_ view: T) -> TableCell<T>? {
        let contentView = view.superview
        let cell = contentView?.superview
        return cell as? TableCell<T>
    }
}

extension UIView {
    
    typealias SideConstraints = (
        top: NSLayoutConstraint,
        leading: NSLayoutConstraint,
        bottom: NSLayoutConstraint,
        trailing: NSLayoutConstraint
    )
    
    @discardableResult
    func addSubviewWithConstraints(_ view: UIView, with insets: UIEdgeInsets = .zero) -> SideConstraints {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = SideConstraints(top: view.topAnchor.constraint(equalTo: topAnchor),
                                          leading: view.leadingAnchor.constraint(equalTo: leadingAnchor),
                                          bottom: view.bottomAnchor.constraint(equalTo: bottomAnchor),
                                          trailing: view.trailingAnchor.constraint(equalTo: trailingAnchor))
        setInsets(insets, for: constraints)
        NSLayoutConstraint.activate([constraints.top,
                                     constraints.leading,
                                     constraints.bottom,
                                     constraints.trailing])
        return constraints
    }
    
    func addConstraints(to view: UIView, insets: UIEdgeInsets = .zero) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right)
            ])
    }
    
    func setInsets(_ insets: UIEdgeInsets, for constraints: SideConstraints) {
        constraints.top.constant = insets.top
        constraints.leading.constant = insets.left
        constraints.bottom.constant = -insets.bottom
        constraints.trailing.constant = -insets.right
    }
}
