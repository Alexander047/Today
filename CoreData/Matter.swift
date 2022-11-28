//
//  Matter.swift
//  Today
//
//  Created by Alexander on 17.11.2020.
//

import Foundation
import CoreData

class Matter: NSManagedObject {
    
    static func fetchAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [Matter] {
        let request: NSFetchRequest<Matter> = Matter.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        guard let tasks = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        return tasks
    }
    
    static func fetch(_ date: Date, viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [Matter] {
        let request: NSFetchRequest<Matter> = Matter.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        request.predicate = NSPredicate(format: "date == %@", date as CVarArg)
        guard let tasks = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        return tasks
    }
    
    static func deleteAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
        Matter.fetchAll(viewContext: viewContext).forEach({ viewContext.delete($0) })
        try? viewContext.save()
    }
}

enum MatterType: Int16 {
    case necessary = 0
    case needed = 1
    case wanted = 2
}
