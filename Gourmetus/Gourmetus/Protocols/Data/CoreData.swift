//
//  CoreData.swift
//  DemoCleanMVVM
//
//  Created by Gabriel Medeiros Martins on 24/10/23.
//

import Foundation
import CoreData

protocol CoreDataSource<T> : DataSource, DataPersistence where T : NSManagedObject {}

extension CoreDataSource {
    var container: NSPersistentContainer { PersistenceController.shared.container }
    
    func fetch() throws -> [T] {
        let request = NSFetchRequest<T>(entityName: T.description())
        return try container.newBackgroundContext().fetch(request)
    }
    
    func save() throws {
        try container.newBackgroundContext().save()
    }
    
    func delete(_ object: T) {
        container.newBackgroundContext().delete(object)
    }
}
