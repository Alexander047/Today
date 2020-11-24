//
//  CalendarVC.swift
//  Today
//
//  Created by Alexander Sheludchenko on 11/11/2020.
//  Copyright © 2020 SealSoft. All rights reserved.
//

import UIKit

protocol CalendarViewInput: class {
    
    func reloadData(_ viewModel: CalendarViewModel)
}

protocol CalendarViewOutput {
    
    func viewDidLoad()
}

private enum Constants {}

final class CalendarVC: UIViewController {
    
    typealias Input = CalendarViewInput
    typealias Output = CalendarViewOutput
    typealias Interactor = CalendarInteractor
    typealias ViewModel = CalendarViewModel
    
    private var viewModel: ViewModel?
    
    private let interactor: Output
    
    private lazy var todayButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Color.button_background_normal()
        button.setTitle("Сегодня", for: .normal)
        button.setTitleColor(Color.button_title_normal(), for: .normal)
        button.titleLabel?.font = .button
        button.addTarget(self, action: #selector(didTapToday), for: .touchUpInside)
        button.layer.cornerRadius = 30
        button.makeConstraints { $0.height.equalTo(60) }
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Color.button_background_normal()
        button.setImage(Image.close(), for: .normal)
        button.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        button.layer.cornerRadius = 30
        button.makeConstraints { $0.size.equalTo(CGSize(width: 60, height: 60)) }
        return button
    }()
    
    init(interactor: Output) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        interactor.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = Color.page()
        view.addSubview(todayButton)
        view.addSubview(closeButton)
        
        
        let label = UILabel()
        label.text = "Колендарь"
        view.addSubview(label)
        label.makeConstraints { (pin) in
            pin.center.equalToSuperView()
        }
    }

    private func setupConstraints() {
        todayButton.makeConstraints { (pin) in
            pin.leading.bottom.equalTo(view.cm.safeArea).inset(16)
        }
        closeButton.makeConstraints { (pin) in
            pin.bottom.trailing.equalTo(view.cm.safeArea).inset(16)
            pin.leading.equalTo(todayButton.cm.trailing).offset(12)
        }
    }
    
    // MARK: - Actions
    @objc
    private func didTapToday() {
        
    }
    
    @objc
    private func didTapClose() {
        dismiss(animated: true)
    }
}

// MARK: - Calendar View Input
extension CalendarVC: CalendarViewInput {
    
    func reloadData(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}
