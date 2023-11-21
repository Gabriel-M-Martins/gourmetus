//
//  StepEntityRepresentable.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 07/11/23.
//

import Foundation

extension Step : EntityRepresentable {
    init?(entityRepresentation: EntityRepresentation) {
        guard let order = entityRepresentation.values["order"] as? Int,
              let title = entityRepresentation.values["title"] as? String else { return nil }
        
        self.id = entityRepresentation.id
        self.title = title
        self.texto = entityRepresentation.values["texto"] as? String
        self.tip = entityRepresentation.values["tip"] as? String
        self.imageData = entityRepresentation.values["image"] as? Data
        self.timer = entityRepresentation.values["timer"] as? Int
        self.order = order
        self.ingredients = entityRepresentation.toManyRelationships["ingredients"] as? [Ingredient] ?? []
    }
    
    func encode() -> EntityRepresentation {
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
        
        let toManyRelationships: [String : [EntityRepresentation]] = [
            "ingredients" : self.ingredients.map({ $0.encode() })
        ]
        
        let toOneRelationships: [String : EntityRepresentation] = [:]
        
        return EntityRepresentation(id: self.id, entityName: "StepEntity", values: values, toOneRelationships: toOneRelationships, toManyRelationships: toManyRelationships)
    }
}
