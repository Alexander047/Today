//
//  CalendarPresenter.swift
//  Today
//
//  Created by Alexander Sheludchenko on 11/11/2020.
//  Copyright © 2020 SealSoft. All rights reserved.
//

import UIKit

protocol CalendarPresenterInput: class {

    func reloadData()
}

private enum Constants {
    
}

final class CalendarPresenter {
    
    typealias ViewModel = CalendarViewModel
    typealias View = CalendarViewInput
    
    private var viewModel: ViewModel?
    
    weak var view: View?
    
}

// MARK: - Calendar Presenter Input
extension CalendarPresenter: CalendarPresenterInput {
    
    func reloadData() {
        view?.reloadData(ViewModel())
    }
}
