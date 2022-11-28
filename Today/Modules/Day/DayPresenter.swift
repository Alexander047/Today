//
//  DayPresenter.swift
//  Today
//
//  Created by Alexander Sheludchenko on 11/11/2020.
//  Copyright © 2020 SealSoft. All rights reserved.
//

import UIKit

protocol DayPresenterInput: AnyObject {
    
    func reloadData(_ matters: [MatterType: [Matter]])
}

private enum Constants {
    
}

final class DayPresenter {
    
    typealias ViewModel = DayViewModel
    typealias View = DayViewInput
    
    private var viewModel: ViewModel?
    
    weak var view: View?
    
    private func makeRows(_ matters: [Matter]) -> [ViewModel.Row] {
        var rows = matters.map({
            ViewModel.Row.matter(
                .init(id: $0.id, isDone: $0.done, text: $0.text)
            )
        })
        rows.append(
            .matter(
                .init(
                    id: ObjectIdentifier(EmptyMatterUUID(UUID())),
                    isDone: false,
                    text: nil
                )
            )
        )
        return rows
    }
}

// MARK: - Day Presenter Input
extension DayPresenter: DayPresenterInput {
    
    func reloadData(_ matters: [MatterType: [Matter]]) {
        var rowsNecessary = makeRows([])
        var rowsNeeded = makeRows([])
        var rowsWanted = makeRows([])
        
        if let matters = matters[.necessary] {
            rowsNecessary = makeRows(matters)
        }
        if let matters = matters[.needed] {
            rowsNeeded = makeRows(matters)
        }
        if let matters = matters[.wanted] {
            rowsWanted = makeRows(matters)
        }
        view?.reloadData(ViewModel(title: "Today", sections: [
            .init(header: "Обязательно", rows: rowsNecessary),
            .init(header: "Нужно", rows: rowsNeeded),
            .init(header: "Хочется", rows: rowsWanted)
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
