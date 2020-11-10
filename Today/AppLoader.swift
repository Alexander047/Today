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
    
//    private var appCoordinator: AppCoordinator?
    
    
    // MARK: - Private
    
    private func setupInrefaseMode() {
//        Preferences.prepareInterfaceMode()
    }
    
    private func setupView() {
        let window = Window(frame: UIScreen.main.bounds)
        self.window = window
        let nc = UINavigationController()//NavigationControllerFactory.makeNavigationController(style: .common)
        window.rootViewController = nc
        window.makeKeyAndVisible()
        window.rootViewController = ViewController()
//        let appCoordinator = AppCoordinator(with: self, nc: nc)
//        appCoordinator.start()
//        self.appCoordinator = appCoordinator
    }
}

extension AppLoader {
    
    // MARK: - Public
    
    public func setupApp() {
        setupInrefaseMode()
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
