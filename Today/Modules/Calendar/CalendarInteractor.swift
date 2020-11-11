//
//  CalendarInteractor.swift
//  Today
//
//  Created by Alexander Sheludchenko on 11/11/2020.
//  Copyright © 2020 SealSoft. All rights reserved.
//

import Foundation

protocol CalendarInteractorInput: class {
    
}

protocol CalendarInteractorOutput: class {
    
}

final class CalendarInteractor {
    
    struct Params {
        
    }
    
    typealias Input = CalendarInteractorInput
    typealias Output = CalendarInteractorOutput
    typealias Presenter = CalendarPresenter
    
    private weak var output: Output?
    private let presenter: Presenter
    private let params: Params
    
    init(output: Output?, presenter: Presenter, params: Params) {
        self.output = output
        self.presenter = presenter
        self.params = params
    }
}

// MARK: - Calendar Interactor Input
extension CalendarInteractor: CalendarInteractorInput {
    
}

// MARK: - Calendar View Output
extension CalendarInteractor: CalendarViewOutput {
    
    func viewDidLoad() {
        presenter.reloadData()
    }
}
