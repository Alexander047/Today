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
                self.groupedMatters = newMatters
                self.presenter.reloadData(
                    title: self.titleFromDate(),
                    matters: self.groupedMatters
                )
            }
        }
    }
    
    func reloadForDate(_ date: Date) {
        params.date = date
        let matters = loadMatters()
        groupedMatters = groupMatters(matters)
        presenter.reloadData(
            title: titleFromDate(),
            matters: groupedMatters
        )
        print("###\n\n", matters.compactMap({ $0.text }).joined(separator: "\n\n"), "\n\n")
    }
}

// MARK: - Day View Output
extension DayInteractor: DayViewOutput {
    
    func viewDidLoad() {
        let matters = loadMatters()
        groupedMatters = groupMatters(matters)
        presenter.reloadData(
            title: titleFromDate(),
            matters: groupedMatters
        )
        print("###\n\n", matters.compactMap({ $0.text }).joined(separator: "\n\n"), "\n\n")
    }
    
    func didTapCalendar() {
        output?.didTapCalendar()
    }
    
    func didEditMatter(at indexPath: IndexPath, text: String?, done: Bool) {
        if
            let matterType = MatterType(rawValue: Int16(indexPath.section)),
            let matter = groupMatters(loadMatters())[matterType]?[safe: indexPath.row]
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
