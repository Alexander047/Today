//
//  DayInteractor.swift
//  Today
//
//  Created by Alexander Sheludchenko on 11/11/2020.
//  Copyright © 2020 SealSoft. All rights reserved.
//

import Foundation

protocol DayInteractorInput: class {
    
}

protocol DayInteractorOutput: class {
    func didTapCalendar()
}

final class DayInteractor {
    
    struct Params {
        
    }
    
    typealias Input = DayInteractorInput
    typealias Output = DayInteractorOutput
    typealias Presenter = DayPresenter
    
    private weak var output: Output?
    private let presenter: Presenter
    private let params: Params
    
    init(output: Output?, presenter: Presenter, params: Params) {
        self.output = output
        self.presenter = presenter
        self.params = params
    }
}

// MARK: - Day Interactor Input
extension DayInteractor: DayInteractorInput {
    
}

// MARK: - Day View Output
extension DayInteractor: DayViewOutput {
    
    func viewDidLoad() {
        presenter.reloadData()
    }
    
    func didTapCalendar() {
        output?.didTapCalendar()
    }
}
