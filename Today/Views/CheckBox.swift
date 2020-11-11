//
//  CheckBox.swift
//  Today
//
//  Created by Alexander on 11.11.2020.
//

import UIKit

class CheckBox: UIView {
    
    private lazy var button: UIButton = {
        let view = UIButton()
        view.setImage(nil, for: .normal)
        view.setImage(Image.check_mark(), for: .selected)
        view.setBackgroundColor(.clear, for: .normal)
        view.setBackgroundColor(Color.button_background_normal(), for: .selected)
        view.layer.cornerRadius = 11
        view.layer.borderWidth = 1.5
        view.layer.masksToBounds = true
        view.makeConstraints { $0.size.equalTo(CGSize(width: 22, height: 22)) }
        view.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return view
    }()
    
    var isSelected: Bool {
        get { button.isSelected }
        set {
            button.isSelected = newValue
            button.layer.borderColor = button.isSelected ? Color.button_border_selected()?.cgColor : Color.button_border_deselected()?.cgColor
        }
    }
    
    var didToggleSelected: ((Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(button)
        button.makeConstraints { $0.edges.equalToSuperView() }
        isSelected = false
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapButton() {
        button.isSelected.toggle()
        didToggleSelected?(button.isSelected)
        button.layer.borderColor = button.isSelected ? Color.button_border_selected()?.cgColor : Color.button_border_deselected()?.cgColor
    }
}
