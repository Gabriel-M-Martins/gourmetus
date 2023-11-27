//
//  CookbookEntityRepresentable.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 07/11/23.
//

import Foundation

extension Cookbook : EntityRepresentable {
    static func decode(representation: EntityRepresentation, visited: inout [UUID : (any EntityRepresentable)?]) -> Self? {
        if let result = visited[representation.id] {
            return (result as? Self)
        }
        
        visited.updateValue(nil, forKey: representation.id)
        
        guard let favoritesRepresentations = representation.toManyRelationships["favorites"],
              let historyRepresentations = representation.toManyRelationships["history"],
              let ownedRecipesRepresentations = representation.toManyRelationships["ownedRecipes"],
              let communityRepresentations = representation.toManyRelationships["community"] else { return nil }
        
        let favorites = favoritesRepresentations.reduce([Recipe]()) { partialResult, innerRepresentation in
            guard let model = Recipe.decode(representation: innerRepresentation, visited: &visited) else { return partialResult }
            
            var result = partialResult
            result.append(model)
            
            return result
        }
        
        let history = historyRepresentations.reduce([Recipe]()) { partialResult, innerRepresentation in
            guard let model = Recipe.decode(representation: innerRepresentation, visited: &visited) else { return partialResult }
            
            var result = partialResult
            result.append(model)
            
            return result
        }
        
        let ownedRecipes = ownedRecipesRepresentations.reduce([Recipe]()) { partialResult, innerRepresentation in
            guard let model = Recipe.decode(representation: innerRepresentation, visited: &visited) else { return partialResult }
            
            var result = partialResult
            result.append(model)
            
            return result
        }
        
        let community = communityRepresentations.reduce([Recipe]()) { partialResult, innerRepresentation in
            guard let model = Recipe.decode(representation: innerRepresentation, visited: &visited) else { return partialResult }
            
            var result = partialResult
            result.append(model)
            
            return result
        }
        
        let result = Self.init(id: representation.id, ownedRecipes: ownedRecipes, favorites: favorites, history: history, community: community)
        visited[representation.id] = result
        
        return result
    }
    
    func encode(visited: inout [UUID : EntityRepresentation]) -> EntityRepresentation {
        if let result = visited[self.id] {
            return result
        }
        
        let result = EntityRepresentation(id: self.id, entityName: "CookbookEntity", values: [:], toOneRelationships: [:], toManyRelationships: [:])
        visited[self.id] = result
        
        let values: [String : Any] = [
            "id" : self.id,
        ]
        
        let toManyRelationships: [String : [EntityRepresentation]] = [
            "ownedRecipes" : self.ownedRecipes.map({ $0.encode(visited: &visited) }),
            "favorites" : self.favorites.map({ $0.encode(visited: &visited) }),
            "history" : self.history.map({ $0.encode(visited: &visited) }),
            "community" : self.community.map({ $0.encode(visited: &visited) }),
        ]
        
        let toOneRelationships: [String : EntityRepresentation] = [:]
        
        result.values = values
        result.toOneRelationships = toOneRelationships
        result.toManyRelationships = toManyRelationships
        
        return result
    }
}


