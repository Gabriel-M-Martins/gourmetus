//
//  StepEntityRepresentable.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 07/11/23.
//

import Foundation

extension Step : EntityRepresentable {
    init?(entityRepresentation: EntityRepresentation) {
        guard let order = entityRepresentation.values["order"] as? Int else { return nil }
        
        self.id = entityRepresentation.id
        self.texto = entityRepresentation.values["texto"] as? String
        self.tip = entityRepresentation.values["tip"] as? String
        self.imageData = entityRepresentation.values["image"] as? Data
        self.timer = entityRepresentation.values["timer"] as? Int
        self.order = order
    }
    
    func encode() -> EntityRepresentation {
        var values: [String : Any] = [
            "id" : self.id,
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
        
        let toManyRelationships: [String : [EntityRepresentation]] = [:]
        
        let toOneRelationships: [String : EntityRepresentation] = [:]
        
        return EntityRepresentation(id: self.id, entityName: "StepEntity", values: values, toOneRelationships: toOneRelationships, toManyRelationships: toManyRelationships)
    }
}
