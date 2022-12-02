//
//  DayPresenter.swift
//  Today
//
//  Created by Alexander Sheludchenko on 11/11/2020.
//  Copyright © 2020 SealSoft. All rights reserved.
//

import UIKit

protocol DayPresenterInput: AnyObject {
    
    func reloadData(title: String?, matters: [MatterType: [Matter]])
}

private enum Constants {
    
}

final class DayPresenter {
    
    typealias ViewModel = DayViewModel
    typealias View = DayViewInput
    
    private var viewModel: ViewModel?
    
    weak var view: View?
    
    private func makeRows(_ matters: [Matter], type: MatterType) -> [ViewModel.Row] {
        var rows = matters.map({
            ViewModel.Row.matter(
                .init(
                    id: $0.id,
                    isDone: $0.done,
                    text: $0.text,
                    sectionType: .init(type)
                )
            )
        })
        rows.append(
            .newMatter(.init(sectionType: .init(type)))
        )
        return rows
    }
}

// MARK: - Day Presenter Input
extension DayPresenter: DayPresenterInput {
    
    func reloadData(title: String?, matters: [MatterType: [Matter]]) {
        let title = title ?? "Today"
        var rowsNecessary = makeRows([], type: .necessary)
        var rowsNeeded = makeRows([], type: .needed)
        var rowsWanted = makeRows([], type: .wanted)
        
        if let matters = matters[.necessary] {
            rowsNecessary = makeRows(matters, type: .necessary)
        }
        if let matters = matters[.needed] {
            rowsNeeded = makeRows(matters, type: .needed)
        }
        if let matters = matters[.wanted] {
            rowsWanted = makeRows(matters, type: .wanted)
        }
        view?.reloadData(ViewModel(title: title, sections: [
            .init(header: "Обязательно", rows: rowsNecessary, type: .necessery),
            .init(header: "Нужно", rows: rowsNeeded, type: .needed),
            .init(header: "Хочется", rows: rowsWanted, type: .wanted)
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
