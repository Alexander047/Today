//
//  DayVC.swift
//  Today
//
//  Created by Alexander Sheludchenko on 11/11/2020.
//  Copyright © 2020 SealSoft. All rights reserved.
//

import UIKit

protocol DayViewInput: class {
    
    func reloadData(_ viewModel: DayViewModel)
}

protocol DayViewOutput {
    
    func viewDidLoad()
    func didTapCalendar()
}

private enum Constants {}

final class DayVC: UIViewController {
    
    typealias Input = DayViewInput
    typealias Output = DayViewOutput
    typealias Interactor = DayInteractor
    typealias ViewModel = DayViewModel
    
    private var viewModel: ViewModel?
    
    private let interactor: Output
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.register(cellWithClass: TableCell<MatterView>.self)
//        view.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        view.insetsContentViewsToSafeArea = true
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private lazy var calendarButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Color.button_background_normal()
        button.setImage(Image.calendar(), for: .normal)
        button.addTarget(self, action: #selector(didTapCalendar), for: .touchUpInside)
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
        view.addSubview(tableView)
        view.addSubview(calendarButton)
//        tableView.scrollRectToVisible(.zero, animated: false)
    }

    private func setupConstraints() {
        tableView.makeConstraints { $0.edges.equalToSuperView() }
        calendarButton.makeConstraints { $0.trailing.bottom.equalTo(view.cm.safeArea).inset(16) }
    }
    
    // MARK: - Actions
    @objc func didTapCalendar() {
        interactor.didTapCalendar()
    }
}

// MARK: - Day View Input
extension DayVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel?.sections[safe: section]?.rows.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = viewModel?.sections[safe: indexPath.section]?.rows[safe: indexPath.row] else {
            return UITableViewCell()
        }
        switch row {
        case .matter(let model):
            let cell = tableView.dequeueReusableCell(withClass: TableCell<MatterView>.self, for: indexPath)
            cell.view.setup(model)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            return cell
        case .comment:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        let label = UILabel()
        label.font = .subtitle
        label.textColor = Color.text_story()
        label.text = viewModel?.sections[safe: section]?.title
        header.addSubview(label)
        label.makeConstraints { (pin) in
            pin.leading.trailing.equalToSuperView().inset(16)
            pin.top.bottom.equalToSuperView().inset(8)
        }
        return header
    }
}

// MARK: - Day View Input
extension DayVC: DayViewInput {
    
    func reloadData(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        title = viewModel.title
        tableView.reloadData()
    }
}
