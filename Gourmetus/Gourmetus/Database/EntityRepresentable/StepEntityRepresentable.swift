//
//  StepEntityRepresentable.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 07/11/23.
//

import Foundation

extension Step : EntityRepresentable {
    static func decode(representation: EntityRepresentation, visited: inout [UUID : (any EntityRepresentable)?]) -> Self? {
        if let result = visited[representation.id] {
            return (result as? Self)
        }
        
        visited.updateValue(nil, forKey: representation.id)
        
        guard let order = representation.values["order"] as? Int,
              let title = representation.values["title"] as? String,
              let ingredientsRepresentations = representation.toManyRelationships["ingredients"] else { return nil }
        
        let texto = representation.values["texto"] as? String
        let tip = representation.values["tip"] as? String
        let imageData = representation.values["image"] as? Data
        let timer = representation.values["timer"] as? Int
        
        let ingredients = ingredientsRepresentations.reduce([Ingredient]()) { partialResult, innerRepresentation in
            guard let model = Ingredient.decode(representation: innerRepresentation, visited: &visited) else { return partialResult }
            
            var result = partialResult
            result.append(model)
            
            return result
        }
        
        let result = Self.init(id: representation.id, title: title, texto: texto, tip: tip, imageData: imageData, timer: timer, ingredients: ingredients, order: order)
        visited[representation.id] = result
        
        return result
    }
    
    func encode(visited: inout [UUID : EntityRepresentation]) -> EntityRepresentation {
        if let result = visited[self.id] {
            return result
        }
        
        let result = EntityRepresentation(id: self.id, entityName: "StepEntity", values: [:], toOneRelationships: [:], toManyRelationships: [:])
        visited[self.id] = result
        
        var values: [String : Any] = [
            "id" : self.id,
            "title" : self.title,
            "order" : self.order
        ]
        
        if self.texto != nil {
            values["texto"] = self.texto!
        }
        
        if self.tip != nil {
            values["tip"] = self.tip!
        }
        
        if self.imageData != nil {
            values["image"] = self.imageData!
        }
        
        if self.timer != nil {
            values["timer"] = self.timer!
        }
        
        let toOneRelationships: [String : EntityRepresentation] = [:]
        
        let toManyRelationships: [String : [EntityRepresentation]] = [
            "ingredients" : self.ingredients.map({ $0.encode(visited: &visited) })]
        
        result.values = values
        result.toOneRelationships = toOneRelationships
        result.toManyRelationships = toManyRelationships
        
        return result
    }
}
