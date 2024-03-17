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
    
    private var currentDate: Date = Date().noon
    
    public required init(_ window: UIWindow) {
        self.window = window
    }

    public func start() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receivedUpdates),
            name: .NSPersistentStoreRemoteChange,
            object: nil
        )
        showDayModule()
    }
    
    public func didBecomeActive() {
        dayModule?.reloadForDate(currentDate)
    }
    
    @objc public func receivedUpdates() {
        dayModule?.receivedUpdates()
    }
    
    private func showDayModule() {
        let module = DayAssembler.build(self, .init(date: currentDate))
        let nc = UINavigationController(rootViewController: module.view)
        nc.navigationBar.prefersLargeTitles = true
        nc.navigationBar.largeTitleTextAttributes = [.foregroundColor: Color.text_primary() ?? UIColor.black,
                                                     .font: UIFont.title]
        window?.rootViewController = nc
        dayModule = module.interactor
    }
}

extension AppCoordinator: DayInteractorOutput {
    
    func didTapCalendar(_ selectedDate: Date) {
        let vc = CalendarVC(selectedDate: selectedDate, output: self)
        window?.rootViewController?.present(vc, animated: true)
    }
}

extension AppCoordinator: CalendarViewOutput {
    
    func viewDidLoad() {
        
    }
    
    func didSelectDate(_ date: Date) {
        currentDate = date
        dayModule?.reloadForDate(date)
    }
}
