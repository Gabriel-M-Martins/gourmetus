//
//  RecipeEntityRepresentable.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 07/11/23.
//

import Foundation

extension Recipe : EntityRepresentable {
    init?(entityRepresentation: EntityRepresentation) {
        guard let name = entityRepresentation.values["name"] as? String,
              let difficulty = entityRepresentation.values["difficulty"] as? Int else { return nil }

        guard let stepsRepresentations = entityRepresentation.toManyRelationships["steps"] else { return nil }
        
        let steps = stepsRepresentations.reduce([Step]()) { partialResult, representation in
            guard let step = Step(entityRepresentation: representation) else { return partialResult }
            
            var result = partialResult
            result.append(step)
            
            return result
        }
        
        guard let ingredientsRepresentations = entityRepresentation.toManyRelationships["ingredients"] else { return nil }
        let ingredients = ingredientsRepresentations.reduce([Ingredient]()) { partialResult, representation in
            guard let ingredient = Ingredient(entityRepresentation: representation) else { return partialResult }
            
            var result = partialResult
            result.append(ingredient)
            
            return result
        }
        
        self.id = entityRepresentation.id
        self.name = name
        self.desc = entityRepresentation.values["desc"] as? String
        self.difficulty = difficulty
        self.imageData = entityRepresentation.values["image"] as? Data
        
        self.steps = steps.sorted(by: { $0.order < $1.order })
        self.ingredients = ingredients
    }
    
    func encode() -> EntityRepresentation {
        let values: [String : Any] = [
            "id" : self.id,
            "name" : self.name,
            "desc" : self.desc as Any,
            "difficulty" : self.difficulty as Any,
            "image" : self.imageData as Any
        ]
        
        let toManyRelationships: [String : [EntityRepresentation]] = [
            "steps" : self.steps.map({ $0.encode() }),
            "ingredients" : self.ingredients.map({ $0.encode() })
        ]
        
        let toOneRelationships: [String : EntityRepresentation] = [:]
        
        return EntityRepresentation(id: self.id, entityName: "RecipeEntity", values: values, toOneRelationships: toOneRelationships, toManyRelationships: toManyRelationships)
    }
    
    
}