//
//  DayInteractor.swift
//  Today
//
//  Created by Alexander Sheludchenko on 11/11/2020.
//  Copyright © 2020 SealSoft. All rights reserved.
//

import Foundation

protocol DayInteractorInput: AnyObject {
    func receivedUpdates()
    func reloadForDate(_ date: Date)
}

protocol DayInteractorOutput: AnyObject {
    func didTapCalendar(_ selectedDate: Date)
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
    
    private var groupedMatters: [MatterType: [Matter]] = [:]
    
    init(output: Output?, presenter: Presenter, params: Params) {
        self.output = output
        self.presenter = presenter
        self.params = params
    }
    
    private func loadMatters() -> [Matter] {
        return Matter.fetch(params.date)
    }
    
    private func groupMatters(_ matters: [Matter]) -> [MatterType: [Matter]] {
        let dict = Dictionary(grouping: matters, by: { $0.section })
        var mattersDict: [MatterType: [Matter]] = [:]
        for (key, value) in dict {
            if let type = MatterType(rawValue: key) {
                mattersDict[type] = value.sorted(by: { $0.order < $1.order })
            }
        }
        return mattersDict
    }
    
    @discardableResult private func makeMatter(
        _ text: String,
        _ date: Date,
        _ order: Int,
        _ section: Int
    ) -> Matter {
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
    
    private func titleFromDate() -> String {
        if params.date == Date().noon {
            return "Today"
        }
        return DateFormatter.mainTitleDate.string(from: params.date)
    }
}

// MARK: - Day Interactor Input
extension DayInteractor: DayInteractorInput {
    
    func receivedUpdates() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let newMatters = self.groupMatters(self.loadMatters())
            if newMatters != self.groupedMatters {
                self.reloadForDate(self.params.date)
            }
        }
    }
    
    func reloadForDate(_ date: Date) {
        params.date = date
        var matters = loadMatters()
        let curNoon = Date().noon
        if date.noon == curNoon {
            // TODO: - добавь отображение прошлых незавершенных дел
//            let pastMatters = Matter.fetchAll().filter {
//                ($0.date.flatMap { date in date.noon < curNoon } ?? false) && !$0.done
//            }
//            matters.append(contentsOf: pastMatters)
        }
        groupedMatters = groupMatters(matters)
        presenter.reloadData(
            title: titleFromDate(),
            matters: groupedMatters,
            date: self.params.date
        )
        updateSharedStorage()
    }
    
    private func updateSharedStorage() {
        let dateStr = DateFormatter.dateByDots.string(from: params.date)
        let key = "Matters_\(dateStr)"
        let mattersTextArray = groupedMatters.elapsedByPriority().map { $0.text }
        
        SharedDefaults.set(
            mattersTextArray, forKey: key
        )
    }
}

// MARK: - Day View Output
extension DayInteractor: DayViewOutput {
    
    func viewDidLoad() {
        reloadForDate(params.date)
    }
    
    func didTapCalendar() {
        output?.didTapCalendar(params.date)
    }
    
    func didEditMatter(at indexPath: IndexPath, text: String?, done: Bool) {
        if
            let matterType = MatterType(rawValue: Int16(indexPath.section)),
            let matter = groupedMatters[matterType]?[safe: indexPath.row]
        {
            if text?.isEmpty == false {
                matter.text = text ?? ""
                matter.done = done
            } else {
                deleteMatter(matter)
            }
        } else if let text = text, !text.isEmpty {
            makeMatter(text, Date().noon, indexPath.row, indexPath.section)
        }
        saveChanges()
    }
}
