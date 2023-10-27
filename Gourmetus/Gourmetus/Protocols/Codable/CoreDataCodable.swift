//
//  CoreDataCodable.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 26/10/23.
//

import Foundation
import CoreData

protocol CoreDataDecodable {
    associatedtype Entity : NSManagedObject
    
    init?(_ entity: Entity)
    
    var id: UUID { get set }
}

protocol CoreDataEncodable {
    associatedtype Entity : NSManagedObject
    
    func encode(context: NSManagedObjectContext, existingEntity: Entity?) -> Entity
}

typealias CoreDataCodable = CoreDataEncodable & CoreDataDecodable
