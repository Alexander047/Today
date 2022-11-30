//
//  CalendarHeaderView.swift
//  Today
//
//  Created by Alexander on 08.02.2021.
//

import UIKit

class CalendarHeaderView: UICollectionReusableView {
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.makeConstraints {
            $0.edges.equalToSuperView()
        }
        titleLabel.textAlignment = .left
        titleLabel.textColor = .label
        titleLabel.font = .subtitle
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CalendarHeaderView {
    
    static func height(_ width: CGFloat) -> CGFloat {
        return 25
    }
}
