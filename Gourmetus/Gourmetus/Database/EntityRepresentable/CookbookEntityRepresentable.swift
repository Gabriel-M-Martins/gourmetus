//
//  CookbookEntityRepresentable.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 07/11/23.
//

import Foundation

extension Cookbook : EntityRepresentable {
    convenience init?(entityRepresentation: EntityRepresentation) {
        guard let favoritesRepresentations = entityRepresentation.toManyRelationships["favorites"],
              let historyRepresentations = entityRepresentation.toManyRelationships["history"],
              let ownedRecipesRepresentations = entityRepresentation.toManyRelationships["ownedRecipes"],
              let communityRepresentations = entityRepresentation.toManyRelationships["community"] else { return nil }
        
        let favorites = favoritesRepresentations.reduce([Recipe]()) { partialResult, representation in
            guard let model = Recipe(entityRepresentation: representation) else { return partialResult }
            
            var result = partialResult
            result.append(model)
            
            return result
        }
        
        let history = historyRepresentations.reduce([Recipe]()) { partialResult, representation in
            guard let model = Recipe(entityRepresentation: representation) else { return partialResult }
            
            var result = partialResult
            result.append(model)
            
            return result
        }
        
        let ownedRecipes = ownedRecipesRepresentations.reduce([Recipe]()) { partialResult, representation in
            guard let model = Recipe(entityRepresentation: representation) else { return partialResult }
            
            var result = partialResult
            result.append(model)
            
            return result
        }
        
        let community = communityRepresentations.reduce([Recipe]()) { partialResult, representation in
            guard let model = Recipe(entityRepresentation: representation) else { return partialResult }
            
            var result = partialResult
            result.append(model)
            
            return result
        }
        
        self.init(id: entityRepresentation.id, ownedRecipes: ownedRecipes, favorites: favorites, history: history, community: community)
    }
    
    func encode() -> EntityRepresentation {
        let values: [String : Any] = [
            "id" : self.id,
        ]
        
        let toManyRelationships: [String : [EntityRepresentation]] = [
            "ownedRecipes" : self.ownedRecipes.map({ $0.encode() }),
            "favorites" : self.favorites.map({ $0.encode() }),
            "history" : self.history.map({ $0.encode() }),
            "community" : self.community.map({ $0.encode() })
        ]
        
        let toOneRelationships: [String : EntityRepresentation] = [:]
        
        return EntityRepresentation(id: self.id, entityName: "CookbookEntity", values: values, toOneRelationships: toOneRelationships, toManyRelationships: toManyRelationships)
    }
}


