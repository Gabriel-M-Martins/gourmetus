//
//  CoreDataRepository.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 26/10/23.
//

import Foundation

protocol CoreDataRepository: Repository {
    associatedtype DataSource : CoreDataSource
    associatedtype Model : CoreDataCodable where Model.Entity == DataSource.SourceType
    
    static var cache: [UUID : DataSource.SourceType] { get set }
}

extension CoreDataRepository {
    static func fetch() -> [Model] {
        guard let entities = try? DataSource.shared.fetch() else { return [] }
        
        var result = [Model]()
        
        for entity in entities {
            if let model = Model(entity) {
                result.append(model)
                Self.cache[model.id] = entity
            }
        }
        
        return result
    }
    
    static func save(_ models: [Model]) {
        for model in models {
            self.save(model)
        }
    }
    
    static func save(_ model: Model) {
        let context = DataSource.shared.container.newBackgroundContext()
        
        let existingEntity = Self.cache[model.id]
        
        let usedContext = existingEntity?.managedObjectContext ?? context
        _ = model.encode(context: usedContext, existingEntity: existingEntity)
        
        try? usedContext.save()
    }
    
    static func delete(_ ids: [UUID]) {
        for id in ids {
            self.delete(id)
        }
    }
    
    static func delete(_ id: UUID) {
        guard let existingEntity = Self.cache[id] else { return }
        
        existingEntity.managedObjectContext?.delete(existingEntity)
        try? existingEntity.managedObjectContext?.save()
    }
}
