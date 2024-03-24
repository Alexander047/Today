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
    func  didSwipeBackward()
    func  didSwipeForward()
}

private enum Constants {
    static let calendarButtonInset: CGFloat = 16
}

private typealias Section = DayViewModel.Section
private typealias SectionType = DayViewModel.SectionType
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
        view.register(cellWithClass: TableCell<AddMatterView>.self)
        //        view.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        if #available(iOS 15.0, *) {
            view.sectionHeaderTopPadding = .leastNormalMagnitude
        }
        view.sectionFooterHeight = .leastNormalMagnitude
        view.sectionHeaderHeight = .leastNormalMagnitude
        view.insetsContentViewsToSafeArea = true
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.dragInteractionEnabled = true
        view.dragDelegate = self
        view.dropDelegate = self
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
    
    private lazy var swipeBackward: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeBackward))
        gesture.direction = .right
        return gesture
    }()
    
    private lazy var swipeForward: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeForward))
        gesture.direction = .left
        return gesture
    }()
    
    private var calendarBottomConstraint: NSLayoutConstraint?
    
    private var dragSourceIndexPath: IndexPath?
    
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
        view.addGestureRecognizer(swipeBackward)
        view.addGestureRecognizer(swipeForward)
        setupKeyboard()
        setupKeyboardNotifications()
    }
    
    private func setupConstraints() {
        tableView.makeConstraints { $0.edges.equalToSuperView() }
        calendarButton.makeConstraints { $0.trailing.equalTo(view.cm.safeArea).inset(Constants.calendarButtonInset) }
        calendarBottomConstraint = calendarButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.calendarButtonInset)
        NSLayoutConstraint.activate([calendarBottomConstraint!])
    }
    
    // MARK: - ACTIONS -
    
    @objc private func didTapCalendar() {
        interactor.didTapCalendar()
    }
    
    @objc private  func  didSwipeBackward() {
        interactor.didSwipeBackward()
    }
    
    @objc private  func  didSwipeForward() {
        interactor.didSwipeForward()
    }
    
    private func startFillingNewMatter(type: SectionType) {
        
    }
}

// MARK: - Builders -

extension DayVC {
    
    private func buildTableViewDataSource() -> DayDiffableDataSource {
        let dataSource: DayDiffableDataSource
        dataSource = .init(tableView: tableView) { [weak self] (tableView, indexPath, _) in
            
            guard let row = self?.viewModel?[indexPath]
            else { return UITableViewCell() }
            
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
                cell.view.didTapNext = { [weak self] in
                    self?.startFillingNewMatter(type: model.sectionType)
                }
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                cell.contentView.backgroundColor = .clear
                return cell
            case .newMatter:
                let cell = tableView.dequeueReusableCell(withClass: TableCell<AddMatterView>.self, for: indexPath)
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                cell.contentView.backgroundColor = .clear
                
                return cell
            }
        }
        dataSource.defaultRowAnimation = .fade
        
        return dataSource
    }
}

// MARK: - Day View Input
extension DayVC: DayViewInput {
    
    func reloadData(_ viewModel: ViewModel) {
        guard viewModel != self.viewModel else { return }
        self.viewModel = viewModel
        title = viewModel.title
        
        let snapshot = snapshotForCurrentState()
        tableViewDataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - TableView Delegates -

extension DayVC: UITableViewDragDelegate {
    
    func tableView(
        _ tableView: UITableView,
        itemsForBeginning session: UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] {
        print("### Items for beginning session")
        guard
            let row = viewModel?[indexPath],
            case Row.matter = row
        else { return [] }
        dragSourceIndexPath = indexPath
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension DayVC: UITableViewDropDelegate {
    
    func tableView(
        _ tableView: UITableView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?
    ) -> UITableViewDropProposal {
        print("### Drop session did update")
        guard
            let sourceIP = dragSourceIndexPath,
            let destIP = destinationIndexPath,
            let section = viewModel?.sections[destIP.section]
        else {
            return UITableViewDropProposal(
                operation: .cancel,
                intent: .unspecified
            )
        }
        if section.type.isButton {
            return UITableViewDropProposal(
                operation: .forbidden,
                intent: .insertAtDestinationIndexPath
            )
        }
        if session.localDragSession != nil { // Drag originated from the same app.
            return UITableViewDropProposal(
                operation: .move,
                intent: .insertAtDestinationIndexPath
            )
        }
        return UITableViewDropProposal(
            operation: .cancel,
            intent: .unspecified
        )
    }
    
    func tableView(
        _ tableView: UITableView,
        performDropWith coordinator: UITableViewDropCoordinator
    ) {
        guard
            let sourceIndexPath: IndexPath = coordinator.items.first?.sourceIndexPath,
            let destinationIndexPath = coordinator.destinationIndexPath,
            var viewModel = viewModel
        else { return }
        
        print("### Perform drop from \(sourceIndexPath) to \(destinationIndexPath)")
        
        viewModel.moveRow(at: sourceIndexPath, to: destinationIndexPath)
        reloadData(viewModel)
    }
}

extension DayVC: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        if section == 0 {
            return 56
        }
        if viewModel?.sections[section].type.isButton == false {
            return 64
        }
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        guard
            let vmSection = viewModel?.sections[section],
            !vmSection.type.isButton
        else { return nil }
        
        let header = UIView()
        let label = UILabel()
        label.font = .subtitle
        label.textColor = Color.text_story()
        label.text = viewModel?.sections[safe: section]?.header
        header.addSubview(label)
        label.makeConstraints { (pin) in
            pin.leading.trailing.equalToSuperView().inset(16)
            pin.bottom.equalToSuperView().inset(8)
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
            guard let self = self else { return }
            let kbHeight = kbFrame.height - self.view.safeAreaInsets.bottom
            let newInset = kbHeight + Constants.calendarButtonInset
            self.calendarBottomConstraint?.constant = -newInset
        }
    }
    
    @objc
    private func keyboardWillHide(_ notification: NSNotification) {
        animateWithKeyboard(notification: notification) { [weak self] kbFrame in
            self?.calendarBottomConstraint?.constant = -Constants.calendarButtonInset
        }
    }
}

extension DayVC {
    private func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<SectionType, Int> {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, Int>()
        guard let viewModel = viewModel else { return snapshot }
        snapshot.appendSections(viewModel.sections.map({ $0.type }))
        for section in viewModel.sections {
            let rows = section.rows.map({ $0.id })
            snapshot.appendItems(rows, toSection: section.type)
        }
        return snapshot
    }
}
