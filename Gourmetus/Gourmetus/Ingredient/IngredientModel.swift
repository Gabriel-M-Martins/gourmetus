//
//  IngredientModel.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 24/10/23.
//

import Foundation
import CoreData

struct IngredientModel {
    var id: UUID
    var name: String
    var quantity: String
    var unit: Unit
}

enum Unit: Int, Codable {
    case Cup
    case Ml
    case L
    case Kg
    case G
}

// MARK: - CoreDataCodable
extension IngredientModel : CoreDataCodable {
    init?(_ entity: Ingredient) {
        let decoder = JSONDecoder()
        
        guard let id = entity.id,
              let name = entity.name,
              let unitData = entity.unit,
              let unit = try? decoder.decode(Unit.self, from: unitData),
              let quantity = entity.quantity else { return nil }
        
        self.id = id
        self.name = name
        self.unit = unit
        self.quantity = quantity
    }
    
    func encode(context: NSManagedObjectContext, existingEntity: Ingredient?) -> Ingredient {
        let entity = existingEntity != nil ? existingEntity! : Ingredient(context: context)
        let encoder = JSONEncoder()
        
        entity.id = self.id
        entity.name = self.name
        entity.quantity = self.quantity
        entity.unit = try? encoder.encode(self.unit)
        
        return entity
    }
}
