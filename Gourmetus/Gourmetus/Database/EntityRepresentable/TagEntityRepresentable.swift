//
//  TagEntityRepresentable.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 08/11/23.
//

import Foundation

extension Tag : EntityRepresentable {
    convenience init?(entityRepresentation: EntityRepresentation) {
        guard let name = entityRepresentation.values["name"] as? String else { return nil }
        
        guard let recipesRepresentations = entityRepresentation.toManyRelationships["recipes"] else { return nil }
        
        let recipes = recipesRepresentations.reduce([Recipe]()) { partialResult, representation in
            guard let model = Recipe(entityRepresentation: representation) else { return partialResult }
            
            var result = partialResult
            result.append(model)
            
            return result
        }
        
        self.init(id: entityRepresentation.id, name: name, recipes: recipes)
    }
    
    func encode() -> EntityRepresentation {
        let values: [String : Any] = [
            "id" : self.id,
            "name" : self.name
        ]
        
        let toOneRelationships: [String : EntityRepresentation] = [
            :
        ]
        
        let toManyRelationships: [String : [EntityRepresentation]] = [
            "recipes" : self.recipes.map({ $0.encode() })
        ]
        
        return EntityRepresentation(id: self.id, entityName: "TagEntity", values: values, toOneRelationships: toOneRelationships, toManyRelationships: toManyRelationships)
    }
    
}
