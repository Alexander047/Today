//
//  DayPresenter.swift
//  Today
//
//  Created by Alexander Sheludchenko on 11/11/2020.
//  Copyright © 2020 SealSoft. All rights reserved.
//

import UIKit

protocol DayPresenterInput: class {
    
    func reloadData()
}

private enum Constants {
    
}

final class DayPresenter {
    
    typealias ViewModel = DayViewModel
    typealias View = DayViewInput
    
    private var viewModel: ViewModel?
    
    weak var view: View?
    
}

// MARK: - Day Presenter Input
extension DayPresenter: DayPresenterInput {
    
    func reloadData() {
        view?.reloadData(ViewModel(title: "Today", sections: [
            .init(title: "Обязательно", rows: [
                .matter(.init(isDone: true, text: "Сделать нормальные заметки")),
                .matter(.init(isDone: false, text: nil))
            ]),
            .init(title: "Нужно", rows: [
                .matter(.init(isDone: false, text: "Написать пример двухстрочного или трёхстрочного дела на макете самого лучшего приложения для ведения дел")),
                .matter(.init(isDone: false, text: nil))
            ]),
            .init(title: "Хочется", rows: [
                .matter(.init(isDone: false, text: nil))
            ])
        ]))
    }
}
