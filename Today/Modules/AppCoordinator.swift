//
//  AppCoordinator.swift
//  Razz
//
//  Created by Alexander on 28.09.2020.
//  Copyright © 2020 Wildberries LLC. All rights reserved.
//

import UIKit

final class AppCoordinator {
    
    private weak var window: UIWindow?
    private weak var dayModule: DayInteractorInput?
    
    public required init(_ window: UIWindow) {
        self.window = window
    }

    public func start() {
        showDayModule()
    }
    
    private func showDayModule() {
        let module = DayAssembler.build(self, .init())
        let nc = UINavigationController(rootViewController: module.view)
        nc.navigationBar.prefersLargeTitles = true
        nc.navigationBar.largeTitleTextAttributes = [.foregroundColor: Color.text_primary() ?? UIColor.black,
                                                     .font: UIFont.title]
        window?.rootViewController = nc
        dayModule = module.interactor
    }
}

extension AppCoordinator: DayInteractorOutput {
    
    func didTapCalendar() {
        let module = CalendarAssembler.build(output: self, params: .init())
        window?.rootViewController?.present(module.view, animated: true)
    }
}

extension AppCoordinator: CalendarInteractorOutput {
    
}
