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
            self?.updateText(selected)
            self?.didToggleSelected?(selected)
        }
        return view
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Новый пункт"
        label.numberOfLines = 1
        label.font = .primary
        label.textColor = Color.text_placeholder()
        return label
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        //  TODO: - ПЕРЕХОД К СЛЕДУЮЩЕМУ ДЕЛУ -
//        textView.returnKeyType = .next
        textView.returnKeyType = .done
        textView.backgroundColor = .clear
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.font = .primary
        textView.textColor = Color.text_primary()
        return textView
    }()
    
    private lazy var moveTomorrowButton: UIButton = {
        let view = UIButton()
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(
            systemName: "arrow.uturn.forward.circle",
            withConfiguration: imageConfiguration
        )
        view.setImage(image, for: .normal)
        view.addTarget(self, action: #selector(didTapMoveTomorrow), for: .touchUpInside)
        view.isEnabled = false
        return view
    }()
    
    var didToggleSelected: ((Bool) -> Void)?
    var moveTomorrow: (() -> Void)?
    var didBeginEditing: (() -> Void)?
    var didChange: ((String?) -> Void)?
    var didEndEditing: ((String?) -> Void)?
    
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
        addSubview(textView)
        addSubview(moveTomorrowButton)
    }
    
    private func setupConstraints() {
        checkBox.makeConstraints { (pin) in
            pin.leading.equalToSuperView().inset(16)
            pin.top.equalToSuperView().inset(8)
        }
        placeholderLabel.makeConstraints { (pin) in
            pin.leading.equalTo(checkBox.cm.trailing).offset(12)
            pin.top.equalToSuperView().inset(8)
            pin.trailing.equalToSuperView().inset(16)
        }
        textView.makeConstraints { (pin) in
            pin.leading.equalTo(checkBox.cm.trailing).offset(12)
            pin.top.bottom.equalToSuperView().inset(8)
            pin.trailing.equalTo(moveTomorrowButton.cm.leading).inset(12)
            pin.bottom.greaterOrEqualTo(placeholderLabel.cm.bottom)
        }
        moveTomorrowButton.makeConstraints { (pin) in
            pin.size.equalTo(CGSize(width: 24, height: 24))
            pin.top.equalToSuperView().inset(8)
            pin.trailing.equalToSuperView().inset(16)
        }
    }
    
    private func updatePlaceholder() {
        let textIsFilled = textView.text.isEmpty == false
        moveTomorrowButton.isEnabled = textIsFilled
        let placeholderAlpha: CGFloat = textIsFilled ? 0 : 1
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.placeholderLabel.alpha = placeholderAlpha
        }
    }
    
    private func updateText(_ selected: Bool) {
        textView.resignFirstResponder()
        let text = textView.attributedText.string.isEmpty ? (textView.text ?? "") : textView.attributedText.string
        var attributes: [NSAttributedString.Key : Any] = [.foregroundColor: Color.text_primary() ?? .black,
                                                          .font: UIFont.primary]
        if selected {
            attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        }
        let attributedText = NSMutableAttributedString(string: text,
                                                       attributes: attributes)
        textView.attributedText = attributedText
        textView.typingAttributes = attributes
        textView.isEditable = !selected
    }
    
    func setup(_ model: DayViewModel.Matter) {
        
        checkBox.isSelected = model.isDone
        textView.text = model.text
        updatePlaceholder()
        updateText(model.isDone)
        textView.isUserInteractionEnabled = model.isEditable
    }
    
    // MARK: - ACTIONS -
    
    @objc private func didTapMoveTomorrow() {
        moveTomorrow?()
    }
}

extension MatterView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            //  TODO: - ПЕРЕХОД К СЛЕДУЮЩЕМУ ДЕЛУ -
//            if let nextMatter = textView.next as? MatterView {
//                nextMatter.textView.becomeFirstResponder()
//            } else {
                textView.resignFirstResponder()
//            }
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        didBeginEditing?()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        didEndEditing?(textView.text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updatePlaceholder()
        didChange?(textView.text)
    }
}
