//
//  MatterView.swift
//  Today
//
//  Created by Alexander on 11.11.2020.
//

import UIKit

class MatterView: UIView {
    
    private lazy var checkBox: CheckBox = {
        let view = CheckBox()
        view.didToggleSelected = { [weak self] (selected) in
            self?.didToggleSelected?(selected)
        }
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.font = .primary
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.makeConstraints { $0.height.equalTo(1) }
        view.backgroundColor = Color.separator()
        return view
    }()
    
    var didToggleSelected: ((Bool) -> Void)?
    
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
        addSubview(label)
    }
    
    private func setupConstraints() {
        checkBox.makeConstraints { (pin) in
            pin.leading.equalToSuperView().inset(16)
            pin.top.equalToSuperView().inset(8)
        }
        label.makeConstraints { (pin) in
            pin.leading.equalTo(checkBox.cm.trailing).offset(12)
            pin.top.equalToSuperView().inset(8)
            pin.trailing.equalToSuperView().inset(16)
        }
    }
    
    func setup(_ model: DayViewModel.Matter) {
        separatorView.removeFromSuperview()
        
        checkBox.isSelected = model.isDone
        let text = model.text ?? "Новый пункт"
        let textColor = (model.text == nil) ? Color.text_placeholder() : Color.text_primary()
        var attributes: [NSAttributedString.Key : Any] = [.foregroundColor: textColor ?? .black,
                                                          .font: UIFont.primary]
        if model.isDone {
            attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        }
        let attributedText = NSMutableAttributedString(string: text,
                                                         attributes: attributes)
        label.attributedText = attributedText
        
        if model.text == nil {
            addSubview(separatorView)
            separatorView.isHidden = false
            separatorView.makeConstraints { (pin) in
                pin.top.equalTo(label.cm.bottom).offset(16)
                pin.leading.trailing.equalToSuperView().inset(16)
                pin.bottom.equalToSuperView()
            }
        } else {
            addSubview(separatorView)
            separatorView.isHidden = true
            separatorView.makeConstraints { (pin) in
                pin.top.equalTo(label.cm.bottom).offset(7)
                pin.leading.trailing.bottom.equalToSuperView()
            }
        }
    }
}
