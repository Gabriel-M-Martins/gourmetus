//
//  IngredientEntityRepresentable.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 07/11/23.
//

import Foundation

extension Ingredient : EntityRepresentable {
    init?(entityRepresentation: EntityRepresentation) {
        let decoder = JSONDecoder()
        guard let name = entityRepresentation.values["name"] as? String,
              let quantity = entityRepresentation.values["quantity"] as? String,
              let unitData = entityRepresentation.values["unit"] as? Data,
              let unit = try? decoder.decode(IngredientUnit.self, from: unitData) else { return nil }
        
        self.id = entityRepresentation.id
        self.name = name
        self.quantity = quantity
        self.unit = unit
    }
    
    func encode() -> EntityRepresentation {
        let encoder = JSONEncoder()
        let values: [String : Any] = [
            "id" : self.id,
            "name" : self.name as Any,
            "quantity" : self.quantity as Any,
            "unit" : (try? encoder.encode(self.unit)) as Any
        ]
        
        let toManyRelationships: [String : [EntityRepresentation]] = [:]
        
        let toOneRelationships: [String : EntityRepresentation] = [:]
        
        return EntityRepresentation(id: self.id, entityName: "IngredientEntity", values: values, toOneRelationships: toOneRelationships, toManyRelationships: toManyRelationships)
    }
}
