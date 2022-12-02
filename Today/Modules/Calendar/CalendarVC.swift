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
    
    static let collectionInsets = UIEdgeInsets(top: 64, left: 16, bottom: 92, right: 16)
    
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
        view.register(cellWithClass: CalendarCVCell.self)
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
    
    private let calendar = Calendar.current
    
    private let selectedDate: Date
    private let selectedDateComponents: Date.DateComponents
    
    private weak var output: Output?
    
    private var selectedCellIndexPath: IndexPath?
    
    init(selectedDate: Date, output: Output? = nil) {
        self.output = output
        self.selectedDate = selectedDate
        self.selectedDateComponents = selectedDate.dateComponents
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
        
        let currentDate = Date().noon
        let currentDateComponents = currentDate.dateComponents
        let maxMonthComponents = Date.DateComponents(
            day: 1,
            month: currentDateComponents.month,
            year: currentDateComponents.year + 2
        )
        
        var dates = Set<Date>(matters.compactMap { $0.date })
        let datesComponents = Set<Date.DateComponents>(dates.map { $0.dateComponents })
        
        let minDateComponents = (dates.min() ?? currentDate).dateComponents
        var minMonthComponents = Date.DateComponents(
            day: 1,
            month: minDateComponents.month,
            year: minDateComponents.year
        )
        
        var sections = [ViewModel.Section]()
        
        while minMonthComponents < maxMonthComponents {
            let (section, firstDayOffset) = generateSection(for: minMonthComponents.date(), datesComponents)
            sections.append(section)
            if
                minMonthComponents.month == selectedDateComponents.month,
                    minMonthComponents.year == selectedDateComponents.year
            {
                selectedCellIndexPath = IndexPath(item: selectedDateComponents.day + firstDayOffset - 1, section: sections.count - 1)
            }
            if minMonthComponents.month < 12 {
                minMonthComponents = .init(
                    day: 1,
                    month: minMonthComponents.month + 1,
                    year: minMonthComponents.year
                )
            } else {
                minMonthComponents = .init(
                    day: 1,
                    month: 1,
                    year: minMonthComponents.year + 1
                )
            }
        }
        
        let viewModel = ViewModel(sections: sections)
        self.viewModel = viewModel
        
        collectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let indexPath = self.selectedCellIndexPath {
                self.collectionView.selectItem(
                    at: indexPath,
                    animated: false,
                    scrollPosition: .centeredVertically
                )
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: indexPath.section), at: .top, animated: false)
                
            }
        }
    }
    
    private func loadMatters() -> [Matter] {
        return Matter.fetchAll()
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
    
    private func didSelectDate(_ date: Date) {
        output?.didSelectDate(date)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: true)
        }
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
        let cell = collectionView.dequeueCell(withClass: CalendarCVCell.self, for: indexPath)
        guard let row = viewModel?[row: indexPath] else { return cell }
        switch row {
        case .day(let day):
            cell.setup(
                .init(
                    day: day.dateComponents.day,
                    hasEvents: day.hasMatters,
                    isWeekend: day.isWeekend
                )
            )
            if day.dateComponents == selectedDateComponents {
                selectedCellIndexPath = indexPath
            }
        case .spacer:
            cell.setup(nil)
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
        
        let date = day.dateComponents.date()
        didSelectDate(date)
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
    
    func generateSection(
        for baseDate: Date,
        _ datesWithNotes: Set<Date.DateComponents>
    ) -> (ViewModel.Section, Int) {
        
        guard let metadata = try? monthMetadata(for: baseDate) else {
            return (.init(title: "", rows: []), 0)
        }
        
        let title = DateFormatter.calendarMonthDate.string(from: baseDate)
        
        let numberOfDaysInMonth = metadata.numberOfDays
        var firstDayWeekday = (metadata.firstDayWeekday + 12) % 7 + 1
        let month = metadata.month
        let year = metadata.year
        
        var rows: [ViewModel.Row] = []
        for day in ((2 - firstDayWeekday)...numberOfDaysInMonth) {
            if day < 1 {
                rows.append(.spacer)
            } else {
                let dateComponents = Date.DateComponents(day: day, month: month, year: year)
                let hasMatters = datesWithNotes.contains(dateComponents)
                rows.append(
                    .day(.init(
                        dateComponents: dateComponents,
                        isWeekend: !(1...5).contains((day + firstDayWeekday - 1) % 7),
                        hasMatters: hasMatters
                    ))
                )
            }
        }
        return (.init(title: title, rows: rows), firstDayWeekday - 1)
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
