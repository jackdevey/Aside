//
//  PersistanceController.swift
//  Aside
//
//  Created by Jack Devey on 01/08/2022.
//

import Foundation
import CoreData

final class PersistanceController {
    static let shared = PersistanceController()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Aside")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistant stores: \(error)")
            }
        }
        return container
    }()
    
    private init() {}
    
    public func saveContext(backgroundContext: NSManagedObjectContext? = nil) throws {
        let context = backgroundContext ?? container.viewContext
        guard context.hasChanges else { return }
        try context.save()
    }
}
