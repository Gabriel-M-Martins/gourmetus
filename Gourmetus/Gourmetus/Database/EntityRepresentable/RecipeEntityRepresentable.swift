//
//  RecipeEntityRepresentable.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 07/11/23.
//

import Foundation

extension Recipe : EntityRepresentable {
    static func decode(representation: EntityRepresentation, visited: inout [UUID : (any EntityRepresentable)?]) -> Self? {
        if let result = visited[representation.id] {
            return (result as? Self)
        }
        
        visited.updateValue(nil, forKey: representation.id)
        
        guard let name = representation.values["name"] as? String,
              let difficulty = representation.values["difficulty"] as? Int,
              let duration = representation.values["duration"] as? Int,
              let rating = representation.values["rating"] as? Float,
              let completed = representation.values["completed"] as? Bool,
              let stepsRepresentations = representation.toManyRelationships["steps"],
              let tagsRepresentations = representation.toManyRelationships["tags"],
              let ingredientsRepresentations = representation.toManyRelationships["ingredients"] else { return nil }

        let desc = representation.values["desc"] as? String
        let imageData = representation.values["image"] as? Data
        
        let steps = stepsRepresentations.reduce([Step]()) { partialResult, innerRepresentation in
            guard let step = Step.decode(representation: innerRepresentation, visited: &visited) else { return partialResult }
            
            var result = partialResult
            result.append(step)
            
            return result
        }
        .sorted(by: { $0.order < $1.order })
        
        let tags = tagsRepresentations.reduce([Tag]()) { partialResult, innerRepresentation in
            guard let model = Tag.decode(representation: innerRepresentation, visited: &visited) else { return partialResult }
            
            var result = partialResult
            result.append(model)
            
            return result
        }
        
        let ingredients = ingredientsRepresentations.reduce([Ingredient]()) { partialResult, innerRepresentation in
            guard let model = Ingredient.decode(representation: innerRepresentation, visited: &visited) else { return partialResult }
            
            var result = partialResult
            result.append(model)
            
            return result
        }
        
        let result = Self.init(id: representation.id, name: name, desc: desc, difficulty: difficulty, rating: rating, imageData: imageData, steps: steps, ingredients: ingredients, tags: tags, duration: duration, completed: completed)
        visited[representation.id] = result
        
        return result
    }
    
    func encode(visited: inout [UUID : EntityRepresentation]) -> EntityRepresentation {
        if let result = visited[self.id] {
            return result
        }
        
        let result = EntityRepresentation(id: self.id, entityName: "RecipeEntity", values: [:], toOneRelationships: [:], toManyRelationships: [:])
        visited[self.id] = result
        
        var values: [String : Any] = [
            "id" : self.id,
            "name" : self.name,
            "difficulty" : self.difficulty as Any,
            "rating" : self.rating as Any,
            "duration" : self.duration as Any,
            "completed" : self.completed as Any
        ]
        
        if self.desc != nil {
            values["desc"] = self.desc!
        }
        
        if self.imageData != nil {
            values["image"] = self.imageData!
        }
        
        let toOneRelationships: [String : EntityRepresentation] = [:]
        
        let toManyRelationships: [String : [EntityRepresentation]] = [
            "steps" : self.steps.map({ $0.encode(visited: &visited) }),
            "ingredients" : self.ingredients.map({ $0.encode(visited: &visited) }),
            "tags" : self.tags.map({ $0.encode(visited: &visited) }),
        ]
        
        result.values = values
        result.toOneRelationships = toOneRelationships
        result.toManyRelationships = toManyRelationships
        
        return result
    }
    
    
}
