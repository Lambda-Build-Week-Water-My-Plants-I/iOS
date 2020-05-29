//
//  CoreDataStack.swift
//  Water My Plants
//
//  Created by Nonye on 5/27/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Water_My_Plants")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        #warning("I think this is what makes it skip and act weird but then again it also then changes the way the edits look??")
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    // MARK: - SAVE FUNC
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var error: Error?
        context.performAndWait {
            do {
                try context.save()
            } catch let saveError {
                error = saveError
            }
        }
        if let error = error { throw error }
    }
}
