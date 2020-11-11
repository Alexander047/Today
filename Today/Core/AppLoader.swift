//
//  AppDelegate.swift
//  Razz
//
//  Created by Alexander Sheludchenko on 10.03.2020.
//  Copyright © 2020 Wildberries LLC. All rights reserved.
//

import UIKit

final class AppLoader {
    
    private var window: UIWindow?
    
    private var appCoordinator: AppCoordinator?
    
    
    // MARK: - Private
    private func setupView() {
        let window = Window(frame: UIScreen.main.bounds)
        self.window = window
        window.makeKeyAndVisible()
        let appCoordinator = AppCoordinator(window)
        appCoordinator.start()
        self.appCoordinator = appCoordinator
    }
}

extension AppLoader {
    
    // MARK: - Public
    
    public func setupApp() {
        setupView()
    }
}

// MARK: - AppCoordinatorOutput

//extension AppLoader: AppCoordinatorOutput {}

class Window: UIWindow {
    
    override func sendEvent(_ event: UIEvent) {
        print("### \(event) \n$$$\(event.debugDescription)\n")
        super.sendEvent(event)
    }
}
