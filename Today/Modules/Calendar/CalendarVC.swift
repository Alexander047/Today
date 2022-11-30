//
//  CalendarVC.swift
//  Today
//
//  Created by Alexander Sheludchenko on 11/11/2020.
//  Copyright © 2020 SealSoft. All rights reserved.
//

import UIKit

protocol CalendarViewOutput: AnyObject {
    
    func viewDidLoad()
    func didSelectDate(_ date: Date)
}

private enum Constants {
    
    static let collectionInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
}

final class CalendarVC: UIViewController {
    
    typealias Output = CalendarViewOutput
    typealias ViewModel = CalendarViewModel
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: view.frame.width - Constants.collectionInsets.horizontal, height: 40)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.register(cellWithClass: CollectionCell<UILabel>.self)
        view.register(CalendarHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        view.contentInset = Constants.collectionInsets
        view.backgroundColor = UIColor.systemGroupedBackground
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
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
    
    private var viewModel: ViewModel?
    
    private let calendar: Calendar = {
        var calendar = Calendar.iso8601
        calendar.firstWeekday = 2
        return calendar
    }()
    
    private weak var output: Output?
    
    init(output: Output? = nil) {
        self.output = output
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
        loadData()
    }
    
    private func setupUI() {
        view.backgroundColor = Color.page()
        view.addSubview(collectionView)
        view.addSubview(todayButton)
        view.addSubview(closeButton)
    }
    
    private func setupConstraints() {
        collectionView.makeConstraints { (pin) in
            pin.edges.equalToSuperView()
        }
        todayButton.makeConstraints { (pin) in
            pin.leading.bottom.equalTo(view.cm.safeArea).inset(16)
        }
        closeButton.makeConstraints { (pin) in
            pin.bottom.trailing.equalTo(view.cm.safeArea).inset(16)
            pin.leading.equalTo(todayButton.cm.trailing).offset(12)
        }
    }
    
    private func loadData() {
        let matters = loadMatters()
        let _ = groupMatters(matters)
        let data = generateSection(for: Date().noon)
        self.viewModel = ViewModel(sections: [data])
        collectionView.reloadData()
    }
    
    private func loadMatters() -> [Matter] {
        return Matter.fetchAll()
    }
    
    private func groupMatters(_ matters: [Matter]) -> [[Matter]] {
        return Dictionary(grouping: matters, by: { $0.section })
            .values
            .sorted(by: { $0[0].section < $1[0].section })
            .map({ $0.sorted(by: { $0.order < $1.order }) })
    }
    
    // MARK: - Actions
    @objc
    private func didTapToday() {
        output?.didSelectDate(Date().noon)
        dismiss(animated: true)
    }
    
    @objc
    private func didTapClose() {
        dismiss(animated: true)
    }
    
    @objc
    private func dateChanged() {
        //        output?.didSelectDate(date)
        dismiss(animated: true)
    }
}

extension CalendarVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.sections.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.sections[safe: section]?.rows.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(withClass: CollectionCell<UILabel>.self, for: indexPath)
        guard let row = viewModel?[row: indexPath] else { return cell }
        switch row {
        case .day(let day):
            cell.setup(for: day)
        case .spacer:
            cell.view.text = nil
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.width - Constants.collectionInsets.horizontal
        let height = CalendarHeaderView.height(width) + 32
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "SectionHeader",
            for: indexPath
        ) as? CalendarHeaderView,
           let section = viewModel?.sections[safe: indexPath.section]
        {
            sectionHeader.titleLabel.text = section.title
            return sectionHeader
        }
        return UICollectionReusableView()
    }
}

extension CalendarVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let row = viewModel?[row: indexPath],
            case ViewModel.Row.day(let day) = row
        else { return }
        
    }
}

extension CalendarVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = ((view.frame.width - Constants.collectionInsets.horizontal - (8.0 * 6.0)) / 7.0).rounded(.down)
        return CGSize(width: width, height: width)
        //        return CGSize(width: width, height: width)
    }
}

private extension CalendarVC {
    
    func generateSection(for baseDate: Date) -> ViewModel.Section {
        
        guard let metadata = try? monthMetadata(for: baseDate) else {
            return .init(title: "", rows: [])
        }
        
        let title = DateFormatter.calendarMonthDate.string(from: baseDate)
        
        let numberOfDaysInMonth = metadata.numberOfDays
        let firstDayWeekday = (metadata.firstDayWeekday + 6) % 7
        let month = metadata.month
        let year = metadata.year
        
        var rows: [ViewModel.Row] = []
        for day in ((2 - firstDayWeekday)...numberOfDaysInMonth) {
            if day < 1 {
                rows.append(.spacer)
            } else {
                rows.append(
                    .day(.init(
                        day: day,
                        month: month,
                        year: year,
                        isWeekend: !(1...5).contains((day + firstDayWeekday - 1) % 7),
                        hasMatters: false
                    ))
                )
            }
        }
        return .init(title: title, rows: rows)
    }
    
    func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
        guard
            let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: baseDate)?.count,
            let firstDayOfMonth = calendar.date(
                from: calendar.dateComponents([.year, .month], from: baseDate)
            )
        else {
            throw CalendarDataError.metadataGeneration
        }
        
        let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let month = calendar.component(.month, from: firstDayOfMonth)
        let year = calendar.component(.year, from: firstDayOfMonth)
        
        return MonthMetadata(
            numberOfDays: numberOfDaysInMonth,
            firstDay: firstDayOfMonth,
            firstDayWeekday: firstDayWeekday,
            month: month,
            year: year
        )
    }
    
    enum CalendarDataError: Error {
        case metadataGeneration
    }
    
    struct MonthMetadata {
        let numberOfDays: Int
        let firstDay: Date
        let firstDayWeekday: Int
        let month: Int
        let year: Int
    }
}

extension CollectionCell<UILabel> {
    
    private enum Constants {
        static let font = UIFont.systemFont(ofSize: 20, weight: .regular)
        static let fontSelected = UIFont.systemFont(ofSize: 20, weight: .semibold)
        static let defaultColor = UIColor.secondaryLabel
        static let hasMattersColor = UIColor.label
        static let weekendColor = UIColor(hex: 0xFF3B30)
        static let selectedColor = UIColor(hex: 0x007AFF)
    }
    
    func setup(for day: CalendarViewModel.Day) {
        view.text = String(day.day)
        view.textAlignment = .center
        view.font = Constants.font
        view.textColor = Constants.defaultColor
        if day.isWeekend {
            view.textColor = Constants.weekendColor
        } else if day.hasMatters {
            view.textColor = Constants.hasMattersColor
        }
    }
}
