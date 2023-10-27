//
//  CoreData.swift
//  DemoCleanMVVM
//
//  Created by Gabriel Medeiros Martins on 24/10/23.
//

import Foundation
import CoreData

protocol CoreDataSource {
    associatedtype SourceType: NSManagedObject
    static var shared: Self { get }
}

extension CoreDataSource {
    var container: NSPersistentContainer { PersistenceController.shared.container }
    
    func fetch() throws -> [SourceType] {
        let request = NSFetchRequest<SourceType>(entityName: SourceType.description())
        return try container.newBackgroundContext().fetch(request)
    }
    
    func fetch(id: UUID) throws -> SourceType? {
        let request = NSFetchRequest<SourceType>(entityName: SourceType.description())
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        return try container.newBackgroundContext().fetch(request).first
    }
    
    func delete(_ object: SourceType) {
        container.newBackgroundContext().delete(object)
    }
}
