//
//  AddMatterView.swift
//  Today
//
//  Created by Alexander on 24.03.2024.
//

import UIKit

class AddMatterView: UIView {
    
    private lazy var checkBox = CheckBox()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Новый пункт"
        label.numberOfLines = 1
        label.font = .primary
        label.textColor = Color.text_placeholder()
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.2)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        addSubview(checkBox)
        addSubview(placeholderLabel)
        addSubview(separatorView)
    }
    
    private func setupConstraints() {
        checkBox.makeConstraints { (pin) in
            pin.leading.equalToSuperView().inset(16)
            pin.top.equalToSuperView().inset(8)
            pin.bottom.equalToSuperView().inset(16)
        }
        placeholderLabel.makeConstraints { (pin) in
            pin.leading.equalTo(checkBox.cm.trailing).offset(12)
            pin.top.equalToSuperView().inset(8)
            pin.trailing.equalToSuperView().inset(16)
        }
        separatorView.makeConstraints {
            $0.bottom.equalToSuperView()
            $0.height.equalTo(0.5)
            $0.leading.trailing.equalToSuperView().inset(16)
        }
    }
}
