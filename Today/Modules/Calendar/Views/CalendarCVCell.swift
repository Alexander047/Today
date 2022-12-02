//
//  CalendarCVCell.swift
//  Today
//
//  Created by Alexander on 08.02.2021.
//

import UIKit

private enum Constants {
    static let circleSize = CGSize(width: 45, height: 45)
    static let borderWidth: CGFloat = 2
    
    static let defaultFont = UIFont.systemFont(ofSize: 20, weight: .regular)
    static let selectedFont = UIFont.systemFont(ofSize: 20, weight: .semibold)
    static let defaultColor = UIColor.secondaryLabel
    static let hasMattersColor = UIColor.label
    static let weekendColor = UIColor(hex: 0xFF3B30)
    static let selectedColor = UIColor(hex: 0x007AFF)
}

class CalendarCVCell: UICollectionViewCell {
    
    private lazy var label = UILabel()
    private let circleView = UIView()
    
    private var day: Day?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(label)
        contentView.addSubview(circleView)
        
        label.textAlignment = .center
        
        self.layer.masksToBounds = false
        
        circleView.backgroundColor = .clear
        circleView.layer.borderWidth = Constants.borderWidth
        circleView.layer.borderColor = Constants.selectedColor.cgColor
        circleView.layer.cornerRadius = Constants.circleSize.width / 2.0
        circleView.isHidden = true
        
        label.makeConstraints {
            $0.edges.equalToSuperView()
        }
        circleView.makeConstraints {
            $0.center.equalToSuperView()
            $0.size.equalTo(Constants.circleSize)
        }
    }
    
    private func update() {
        guard let day = day else {
            isHidden = true
            return
        }
        isHidden = false
        circleView.isHidden = !isSelected
        
        label.text = String(day.day)
        label.font = Constants.defaultFont
        label.textColor = Constants.defaultColor
        
        if day.isWeekend {
            label.textColor = Constants.weekendColor
        } else {
            if isSelected {
                label.textColor = Constants.selectedColor
                label.font = Constants.selectedFont
            } else if day.hasEvents {
                label.textColor = Constants.hasMattersColor
            }
        }
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
