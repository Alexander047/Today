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
    
    private let calendar = Calendar(identifier: .gregorian)
    
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
        let groupedMatters = groupMatters(matters)
        
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
        
    }
    
    @objc
    private func didTapClose() {
        dismiss(animated: true)
    }
}

extension CalendarVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(withClass: CollectionCell<UILabel>.self, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.width - Constants.collectionInsets.horizontal
        let height = CalendarHeaderView.height(width)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? CalendarHeaderView {
            
            return sectionHeader
        }
        return UICollectionReusableView()
    }
}

extension CalendarVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension CalendarVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 40) / 2
        return CGSize(width: width, height: width)
    }
}
