//
//  DayInteractor.swift
//  Today
//
//  Created by Alexander Sheludchenko on 11/11/2020.
//  Copyright © 2020 SealSoft. All rights reserved.
//

import Foundation

protocol DayInteractorInput: class {
    func receivedUpdates()
    func reloadForDate(_ date: Date)
}

protocol DayInteractorOutput: class {
    func didTapCalendar()
}

final class DayInteractor {
    
    struct Params {
        var date: Date
    }
    
    typealias Input = DayInteractorInput
    typealias Output = DayInteractorOutput
    typealias Presenter = DayPresenter
    
    private weak var output: Output?
    private let presenter: Presenter
    private var params: Params
    
    private var groupedMatters: [[Matter]] = []
    
    init(output: Output?, presenter: Presenter, params: Params) {
        self.output = output
        self.presenter = presenter
        self.params = params
    }
    
    private func loadMatters() -> [Matter] {
        return Matter.fetch(params.date)
    }
    
    private func groupMatters(_ matters: [Matter]) -> [[Matter]] {
        return Dictionary(grouping: matters, by: { $0.section })
            .values
            .sorted(by: { $0[0].section < $1[0].section })
            .map({ $0.sorted(by: { $0.order < $1.order }) })
    }
    
    @discardableResult private func makeMatter(_ text: String, _ date: Date, _ order: Int, _ section: Int) -> Matter {
        let matter = Matter(context: AppDelegate.viewContext)
        matter.text = text
        matter.date = date
        matter.order = Int16(order)
        matter.section = Int16(section)
        matter.done = false
        return matter
    }
    
    private func deleteMatter(_ matter: Matter) {
        AppDelegate.viewContext.delete(matter)
    }
    
    private func saveChanges() {
        try? AppDelegate.viewContext.save()
    }
}

// MARK: - Day Interactor Input
extension DayInteractor: DayInteractorInput {
    
    func receivedUpdates() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.groupedMatters = self.groupMatters(self.loadMatters())
            self.presenter.reloadData(self.groupedMatters)
        }
    }
    
    func reloadForDate(_ date: Date) {
        params.date = date
        let matters = loadMatters()
        groupedMatters = groupMatters(matters)
        presenter.reloadData(groupedMatters)
        print("###\n\n", matters.compactMap({ $0.text }).joined(separator: "\n\n"), "\n\n")
    }
}

// MARK: - Day View Output
extension DayInteractor: DayViewOutput {
    
    func viewDidLoad() {
        let matters = loadMatters()
        groupedMatters = groupMatters(matters)
        presenter.reloadData(groupedMatters)
        print("###\n\n", matters.compactMap({ $0.text }).joined(separator: "\n\n"), "\n\n")
    }
    
    func didTapCalendar() {
        output?.didTapCalendar()
    }
    
    func didEditMatter(at indexPath: IndexPath, text: String?, done: Bool) {
        if let matter = groupMatters(loadMatters())[safe: indexPath.section]?[safe: indexPath.row] {
            if text?.isEmpty == false {
                matter.text = text ?? ""
                matter.done = done
                saveChanges()
            } else {
                deleteMatter(matter)
            }
        } else if let text = text, !text.isEmpty {
            makeMatter(text, Date().noon, indexPath.row, indexPath.section)
            saveChanges()
//            presenter.reloadData(groupMatters(loadMatters()))
        }
    }
}
