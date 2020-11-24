//
//  DayPresenter.swift
//  Today
//
//  Created by Alexander Sheludchenko on 11/11/2020.
//  Copyright © 2020 SealSoft. All rights reserved.
//

import UIKit

protocol DayPresenterInput: class {
    
    func reloadData(_ matters: [[Matter]])
}

private enum Constants {
    
}

final class DayPresenter {
    
    typealias ViewModel = DayViewModel
    typealias View = DayViewInput
    
    private var viewModel: ViewModel?
    
    weak var view: View?
    
    private func makeRows(_ matters: [Matter]) -> [ViewModel.Row] {
        var rows = matters.map({ ViewModel.Row.matter(.init(isDone: $0.done, text: $0.text)) })
        rows.append(ViewModel.Row.matter(.init(isDone: false, text: nil)))
        return rows
    }
}

// MARK: - Day Presenter Input
extension DayPresenter: DayPresenterInput {
    
    func reloadData(_ matters: [[Matter]]) {
        view?.reloadData(ViewModel(title: "Today", sections: [
            .init(header: "Обязательно", rows: makeRows(matters[safe: 0] ?? [])),
            .init(header: "Нужно", rows: makeRows(matters[safe: 1] ?? [])),
            .init(header: "Хочется", rows: makeRows(matters[safe: 2] ?? []))
        ]))
    }
}
