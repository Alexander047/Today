//
//  DayPresenter.swift
//  Today
//
//  Created by Alexander Sheludchenko on 11/11/2020.
//  Copyright © 2020 SealSoft. All rights reserved.
//

import UIKit

protocol DayPresenterInput: AnyObject {
    
    func reloadData(title: String?, matters: [MatterType: [Matter]], date: Date)
}

private enum Constants {
    
}

final class DayPresenter {
    
    typealias ViewModel = DayViewModel
    typealias View = DayViewInput
    
    private var viewModel: ViewModel?
    
    weak var view: View?
    
    private func makeRows(_ matters: [Matter], type: MatterType, isPast: Bool) -> [ViewModel.Row] {
        var rows = matters.map({
            ViewModel.Row.matter(
                .init(
                    id: $0.id,
                    isDone: $0.done,
                    text: $0.text,
                    isEditable: !isPast,
                    sectionType: .init(type)
                )
            )
        })
        return rows
    }
}

// MARK: - Day Presenter Input
extension DayPresenter: DayPresenterInput {
    
    func reloadData(title: String?, matters: [MatterType: [Matter]], date: Date) {
        let isPast = date.noon < Date().noon
        let title = title ?? "Today"
        var rowsNecessary = makeRows([], type: .necessary, isPast: isPast)
        var rowsNeeded = makeRows([], type: .needed, isPast: isPast)
        var rowsWanted = makeRows([], type: .wanted, isPast: isPast)
        
        if let matters = matters[.necessary] {
            rowsNecessary = makeRows(matters, type: .necessary, isPast: isPast)
        }
        if let matters = matters[.needed] {
            rowsNeeded = makeRows(matters, type: .needed, isPast: isPast)
        }
        if let matters = matters[.wanted] {
            rowsWanted = makeRows(matters, type: .wanted, isPast: isPast)
        }
        let rowsNecesseryButton = [ViewModel.Row.newMatter(.init(sectionType: .necesseryButton))]
        let rowsNeededButton = [ViewModel.Row.newMatter(.init(sectionType: .neededButton))]
        let rowsWantedButton = [ViewModel.Row.newMatter(.init(sectionType: .wantedButton))]
        view?.reloadData(ViewModel(title: title, sections: [
            .init(header: "Обязательно", rows: rowsNecessary, type: .necessery),
            .init(rows: rowsNecesseryButton, type: .necesseryButton),
            .init(header: "Нужно", rows: rowsNeeded, type: .needed),
            .init(rows: rowsNeededButton, type: .neededButton),
            .init(header: "Хочется", rows: rowsWanted, type: .wanted),
            .init(rows: rowsWantedButton, type: .wantedButton)
        ]))
    }
}

final class EmptyMatterUUID: Hashable {
    
    let id: UUID
    
    init(_ id: UUID) {
        self.id = id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: EmptyMatterUUID, rhs: EmptyMatterUUID) -> Bool {
        return lhs.id == rhs.id
    }
}
