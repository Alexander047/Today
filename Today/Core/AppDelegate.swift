//
//  AppDelegate.swift
//  Today
//
//  Created by Alexander on 10.11.2020.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var appLoader: AppLoader?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        loadApp()
        return true
    }
    
    private func loadApp() {
        appLoader = AppLoader()
        appLoader?.setupApp()
    }
}

