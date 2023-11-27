//
//  IngredientEntityRepresentable.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 07/11/23.
//

import Foundation

extension Ingredient : EntityRepresentable {
    static func decode(representation: EntityRepresentation, visited: inout [UUID : (any EntityRepresentable)?]) -> Self? {
        if let result = visited[representation.id] {
            return (result as? Self)
        }
        
        visited.updateValue(nil, forKey: representation.id)
        
        let decoder = JSONDecoder()
        guard let name = representation.values["name"] as? String,
              let quantity = representation.values["quantity"] as? String,
              let unitData = representation.values["unit"] as? Data,
              let unit = try? decoder.decode(IngredientUnit.self, from: unitData) else { return nil }
        
        let result = Self.init(id: representation.id, name: name, quantity: quantity, unit: unit)
        visited[representation.id] = result
        
        return result
    }
    
    func encode(visited: inout [UUID : EntityRepresentation]) -> EntityRepresentation {
        if let result = visited[self.id] {
            return result
        }
        
        let result = EntityRepresentation(id: self.id, entityName: "IngredientEntity", values: [:], toOneRelationships: [:], toManyRelationships: [:])
        visited[self.id] = result
        
        let encoder = JSONEncoder()
        var values: [String : Any] = [
            "id" : self.id,
            "name" : self.name as Any,
            "quantity" : self.quantity as Any,
        ]
        
        if let unit = try? encoder.encode(self.unit) {
            values["unit"] = unit
        }
        
        let toManyRelationships: [String : [EntityRepresentation]] = [:]
        
        let toOneRelationships: [String : EntityRepresentation] = [:]
        
        result.values = values
        result.toOneRelationships = toOneRelationships
        result.toManyRelationships = toManyRelationships
        
        return result
    }
}
