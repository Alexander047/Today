//
//  CalendarAssembler.swift
//  Today
//
//  Created by Alexander Sheludchenko on 11/11/2020.
//  Copyright © 2020 SealSoft. All rights reserved.
//

import Foundation

final class CalendarAssembler {

    static func build(output: CalendarInteractorOutput?, params: CalendarInteractor.Params) -> Module<CalendarInteractorInput> {
        let presenter = CalendarPresenter()
        let interactor = CalendarInteractor(output: output, presenter: presenter, params: params)
        let view = CalendarVC(interactor: interactor)
        presenter.view = view
        
        return Module(interactor: interactor, view: view)
    }

}
