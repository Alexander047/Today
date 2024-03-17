//
//  AppDelegate.swift
//  Today
//
//  Created by Alexander on 10.11.2020.
//

import UIKit
import CoreData

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var appLoader: AppLoader?
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Matters")
        
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("###\(#function): Failed to retrieve a persistent store description.")
        }
        description.setOption(true as NSNumber, forKey: "NSPersistentHistoryTrackingKey")
        description.setOption(true as NSNumber, forKey: "NSPersistentStoreRemoteChangeNotificationOptionKey")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        do {
            try container.viewContext.setQueryGenerationFrom(.current)
        } catch {
            fatalError("###\(#function): Failed to pin viewContext to the current generation:\(error)")
        }
        
        return container
    }()
    
    static var persistentContainer: NSPersistentContainer {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    static var viewContext: NSManagedObjectContext {
        let viewContext = persistentContainer.viewContext
        viewContext.automaticallyMergesChangesFromParent = true
        return viewContext
    }
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        loadApp()
        return true
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        //        appLoader?.receivedUpdates()
    }
    
    func applicationDidBecomeActive(
        _ application: UIApplication
    ) {
        print("### Did become active")
        appLoader?.didBecomeActive()
    }
    
    private func loadApp() {
        appLoader = AppLoader()
        appLoader?.setupApp()
    }
}

