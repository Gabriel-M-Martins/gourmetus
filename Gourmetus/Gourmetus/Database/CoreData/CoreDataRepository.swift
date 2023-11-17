//
//  CoreDataRepository.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 26/10/23.
//

import CoreData


final class CoreDataRepository<Model>: Repository where Model: EntityRepresentable {
    private var container: NSPersistentContainer { PersistenceController.shared.container }
    
    // TODO: tirar a cache e fazer o save dar um fetch no banco p/ checar se ja existe
    private var entityName: String
    
    init(_ entityName: String) {
        self.entityName = entityName
    }
    
    func delete(_ id: UUID) {
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        let fetchedResults = (try? container.viewContext.fetch(request)) ?? []
        for result in fetchedResults {
            container.viewContext.delete(result)
        }
    }
    
    private func fetch(_ entityName: String) -> [NSManagedObject] {
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        return (try? container.viewContext.fetch(request)) ?? []
    }
    
    func fetch(id: UUID) -> Model? {
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        guard let fetchedResult = (try? container.viewContext.fetch(request))?.first else { return nil }
        
        guard let representation = traverseRelationships(object: fetchedResult, visited: Set()) else { return nil }
        
        return Model(entityRepresentation: representation)
    }
    
    func fetch() -> [Model] {
        var result = [Model]()
        
        let fetchResults = fetch(self.entityName)
        for fetchResult in fetchResults {
            guard let representation = traverseRelationships(object: fetchResult, visited: Set()) else { continue }
            
            if let model = Model(entityRepresentation: representation) {
                result.append(model)
            }
        }
        
        return result
    }
    
    
    func save(_ model: Model) {
        let representation = model.encode()
        
        guard let entity = traverseRelationships(representation: representation, visited: [:]) else { return }
        
        try? entity.managedObjectContext?.save()
    }
    
    func save(_ models: [Model]) {
        for model in models {
            save(model)
        }
    }
}

extension CoreDataRepository {
    private func representationToEntity(representation: EntityRepresentation, context: NSManagedObjectContext?) -> NSManagedObject? {
        guard let entityDescription = container.managedObjectModel.entitiesByName[representation.entityName] else { return nil }
        
        let existingEntity = fetch(representation.entityName).first(where: { $0.value(forKey: "id") as? UUID == representation.id })
        
        let context = context ?? existingEntity?.managedObjectContext ?? container.viewContext
        let entity = existingEntity ?? NSManagedObject(entity: entityDescription, insertInto: context)

        return entity
    }
    
    private func populateEntity(values: [String : Any], entity: NSManagedObject) {
        for (key, value) in values {
            entity.setValue(value, forKey: key)
        }
    }
    
    private func traverseRelationships(object: NSManagedObject, visited: Set<UUID>) -> EntityRepresentation? {
        guard let id = object.value(forKey: "id") as? UUID,
              let entityName = object.entity.name else { return nil }
        
        var newVisited = visited
        
        let attributes = object.entity.attributesByName.map({ $0.key })
        
        let keysToOneRelationships = object.entity.relationshipsByName.reduce([String]()) { partialResult, item in
            var result = partialResult
            if !item.value.isToMany {
                result.append(item.key)
            }
            return result
        }
        
        var toOneRelationships = [String : EntityRepresentation]()
        for key in keysToOneRelationships {
            guard let relationship = object.value(forKey: key) as? NSManagedObject,
                  let relationshipId = object.value(forKey: "id") as? UUID else { continue }
            
            if !visited.contains(relationshipId) {
                newVisited.insert(id)
                let representation = traverseRelationships(object: relationship, visited: newVisited)
                toOneRelationships[key] = representation
            }
        }
        
        let keysToManyRelationships = object.entity.relationshipsByName.reduce([String]()) { partialResult, item in
            var result = partialResult
            if item.value.isToMany {
                result.append(item.key)
            }
            return result
        }
        
        var toManyRelationships = [String : [EntityRepresentation]]()
        for key in keysToManyRelationships {
            guard let relationships = object.value(forKey: key) as? NSSet,
                  let relationshipId = object.value(forKey: "id") as? UUID else { continue }

            if !visited.contains(relationshipId) {
                newVisited.insert(id)
                
                var representations = [EntityRepresentation]()
                
                for relationship in relationships.allObjects as? [NSManagedObject] ?? [] {
                    guard let rep = traverseRelationships(object: relationship, visited: newVisited) else { continue }
                    representations.append(rep)
                }
                
                toManyRelationships[key] = representations
            }
        }
        
        
        let representation = EntityRepresentation(id: id, entityName: entityName, values: object.dictionaryWithValues(forKeys: attributes), toOneRelationships: toOneRelationships, toManyRelationships: toManyRelationships)
        
        return representation
    }
    
    private func traverseRelationships(representation: EntityRepresentation, visited: [UUID : EntityRepresentation], context: NSManagedObjectContext? = nil) -> NSManagedObject? {
        guard let entityParent = representationToEntity(representation: representation, context: context) else { return nil }
        populateEntity(values: representation.values, entity: entityParent)
        
        var entitiesVisited = visited
        let sonsToOne = representation.toOneRelationships.map { (key: String, value: EntityRepresentation) in
            return (key: key, value: value)
        }
        
        for son in sonsToOne {
            if let _ = entitiesVisited[son.value.id] {
                continue
            }
            
            entitiesVisited[son.value.id] = son.value
            
            if let entitySon = traverseRelationships(representation: son.value, visited: entitiesVisited, context: entityParent.managedObjectContext),
               let relationship = entityParent.entity.relationships(forDestination: entitySon.entity).first(where: {$0.name == son.key}) {
            
                entityParent.setValue(entitySon, forKey: relationship.name)
            }
        }
        
        let sonsToMany = representation.toManyRelationships.map { (key: String, value: [EntityRepresentation]) in
            return (key: key, values: value)
        }
        
        for son in sonsToMany {
            var childrenToAdd = [NSManagedObject]()
            
            for sonK in son.values {
                if let _ = entitiesVisited[sonK.id] {
                    continue
                }
                
                entitiesVisited[sonK.id] = sonK
                
                if let entitySon = traverseRelationships(representation: sonK, visited: entitiesVisited, context: entityParent.managedObjectContext) {
                    childrenToAdd.append(entitySon)
                }
            }
            
            if childrenToAdd.isEmpty { continue }
            
            if let relationship = entityParent.entity.relationships(forDestination: childrenToAdd[0].entity).first(where: { $0.name == son.key }) {
                
                entityParent.setValue(NSSet(array: childrenToAdd), forKey: relationship.name)
            }
        }

        return entityParent
    }
}
