//
//  CalendarCVCell.swift
//  Today
//
//  Created by Alexander on 08.02.2021.
//

import UIKit

private enum Constants {
    static let size = CGSize(width: 45, height: 45)
    static let borderWidth: CGFloat = 2
}

class CalendarCVCell: UICollectionViewCell {
    
    private lazy var label = UILabel()
    
    private var day: Day?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(label)
        label.makeConstraints { (pin) in
            pin.edges.equalToSuperView()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func update() {
        guard let day = day else {
            isHidden = true
            return
        }
        isHidden = false
        layer.borderWidth = isSelected ? Constants.borderWidth : .zero
        layer.borderColor = day.isWeekend ? Color.button_border_distructive()?.cgColor : Color.button_border_selected()?.cgColor
        label.text = "\(day.day)"
        label.textColor = day.isWeekend ? Color.text_destructive() : day.hasEvents ? Color.text_primary() : Color.text_empty()
        label.font = isSelected ? .dateToday : day.hasEvents ? .dateFilled : .dateEmpty
    }
    
    func setup(_ day: Day?) {
        self.day = day
        update()
    }
    
    override var isSelected: Bool {
        didSet {
            update()
        }
    }
}

extension CalendarCVCell {
    
    static func size() -> CGSize {
        return Constants.size
    }
}
