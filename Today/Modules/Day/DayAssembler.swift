//
//  DayAssembler.swift
//  Today
//
//  Created by Alexander Sheludchenko on 11/11/2020.
//  Copyright © 2020 SealSoft. All rights reserved.
//

import Foundation

final class DayAssembler {

    static func build(_ output: DayInteractorOutput?, _ params: DayInteractor.Params) -> Module<DayInteractorInput> {
        let presenter = DayPresenter()
        let interactor = DayInteractor(output: output, presenter: presenter, params: params)
        let view = DayVC(interactor: interactor)
        presenter.view = view
        
        return Module(interactor: interactor, view: view)
    }

}
