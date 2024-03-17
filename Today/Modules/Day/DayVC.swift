//
//  DayVC.swift
//  Today
//
//  Created by Alexander Sheludchenko on 11/11/2020.
//  Copyright © 2020 SealSoft. All rights reserved.
//

import UIKit

protocol DayViewInput: AnyObject {
    
    func reloadData(_ viewModel: DayViewModel)
}

protocol DayViewOutput {
    
    func viewDidLoad()
    func didTapCalendar()
    func didEditMatter(at indexPath: IndexPath, text: String?, done: Bool)
    func moveMatterToNextDay(at indexPath: IndexPath)
}

private enum Constants {
    static let calendarButtonInset: CGFloat = 16
}

private typealias Section = DayViewModel.Section
private typealias Row = DayViewModel.Row

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
    
    private var calendarBottomConstraint: NSLayoutConstraint?
    
    private lazy var tableViewDataSource = buildTableViewDataSource()
    
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
        setupKeyboard()
        setupKeyboardNotifications()
    }
    
    private func setupConstraints() {
        tableView.makeConstraints { $0.edges.equalToSuperView() }
        calendarButton.makeConstraints { $0.trailing.equalTo(view.cm.safeArea).inset(Constants.calendarButtonInset) }
        calendarBottomConstraint = calendarButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.calendarButtonInset)
        NSLayoutConstraint.activate([calendarBottomConstraint!])
    }
    
    // MARK: - Actions
    @objc func didTapCalendar() {
        interactor.didTapCalendar()
    }
}

// MARK: - Day View Input
extension DayVC: UITableViewDelegate {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return viewModel?.sections.count ?? .zero
//    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return  viewModel?.sections[safe: section]?.rows.count ?? .zero
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        let label = UILabel()
        label.font = .subtitle
        label.textColor = Color.text_story()
        label.text = viewModel?.sections[safe: section]?.header
        header.addSubview(label)
        label.makeConstraints { (pin) in
            pin.leading.trailing.equalToSuperView().inset(16)
            pin.top.bottom.equalToSuperView().inset(8)
        }
        return header
    }
}

// MARK: - Keyboard
extension DayVC {
    
    private func setupKeyboard() {
        tableView.keyboardDismissMode = .onDrag
        NotificationCenter.default.addObserver(tableView,
                                               selector: #selector(tableView.didChangeKeyboardFrame),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        // Subscribe to Keyboard Will Hide notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc
    private func keyboardWillShow(_ notification: NSNotification) {
        animateWithKeyboard(notification: notification) { [weak self] kbFrame in
            self?.calendarBottomConstraint?.constant = -kbFrame.height - Constants.calendarButtonInset
        }
    }
    
    @objc
    private func keyboardWillHide(_ notification: NSNotification) {
        animateWithKeyboard(notification: notification) { [weak self] kbFrame in
            self?.calendarBottomConstraint?.constant = -Constants.calendarButtonInset
        }
    }
}

// MARK: - Day View Input
extension DayVC: DayViewInput {
    
    func reloadData(_ viewModel: ViewModel) {
        guard viewModel != self.viewModel else { return }
        self.viewModel = viewModel
        title = viewModel.title
        
        let snapshot = snapshotForCurrentState()
        tableViewDataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Builders -

extension DayVC {
    
    private func buildTableViewDataSource() -> UITableViewDiffableDataSource<Section, Row> {
        let dataSource = UITableViewDiffableDataSource<Section, Row>(tableView: tableView) { (tableView, indexPath, row) in
            
            switch row {
            case .matter(let model):
                let cell = tableView.dequeueReusableCell(withClass: TableCell<MatterView>.self, for: indexPath)
                cell.view.setup(model)
                cell.view.didBeginEditing = {
                    
                }
                cell.view.didChange = { [weak self] text in
                    self?.tableView.beginUpdates()
                    self?.tableView.endUpdates()
                }
                cell.view.didEndEditing = { [weak self] text in
                    let cleanText = text?.trimmingCharacters(in: .whitespacesAndNewlines)
                    if let row = self?.viewModel?.sections[indexPath.section].rows[indexPath.row], case ViewModel.Row.matter(let matter) = row {
                        matter.text = cleanText
                        self?.interactor.didEditMatter(at: indexPath, text: cleanText, done: matter.isDone)
                    }
                }
                cell.view.didToggleSelected = { [weak self] done in
                    self?.view.endEditing(true)
                    if let row = self?.viewModel?.sections[indexPath.section].rows[indexPath.row], case ViewModel.Row.matter(let matter) = row {
                        matter.isDone = done
                        self?.interactor.didEditMatter(at: indexPath, text: matter.text, done: done)
                    }
                }
                cell.view.moveTomorrow = { [weak self] in
                    if let row = self?.viewModel?.sections[indexPath.section].rows[indexPath.row], case ViewModel.Row.matter(_) = row {
                        self?.interactor.moveMatterToNextDay(at: indexPath)
                    }
                }
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                cell.contentView.backgroundColor = .clear
                return cell
            case .newMatter(let model):
                let cell = tableView.dequeueReusableCell(withClass: TableCell<MatterView>.self, for: indexPath)
                cell.view.setup(
                    DayViewModel.Matter(
                        id: ObjectIdentifier(cell),
                        isDone: false,
                        text: nil,
                        isEditable: true,
                        sectionType: model.sectionType
                    )
                )
                cell.view.didChange = { [weak self] text in
                    self?.tableView.beginUpdates()
                    self?.tableView.endUpdates()
                }
                cell.view.didEndEditing = { [weak self] (text) in
                    let cleanText = text?.trimmingCharacters(in: .whitespacesAndNewlines)
                    self?.interactor.didEditMatter(at: indexPath, text: cleanText, done: false)
                }
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                cell.contentView.backgroundColor = .clear
                return cell
            }
        }
        
        return dataSource
    }
}

extension DayVC {
    private func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, Row> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
        guard let viewModel = viewModel else { return snapshot }
        for section in viewModel.sections {
            snapshot.appendSections([section])
            snapshot.appendItems(section.rows)
        }
        return snapshot
    }
}
