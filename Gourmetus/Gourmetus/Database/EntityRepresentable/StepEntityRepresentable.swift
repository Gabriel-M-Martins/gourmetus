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
        self.title = entityRepresentation.values["title"] as? String
        self.texto = entityRepresentation.values["texto"] as? String
        self.tip = entityRepresentation.values["tip"] as? String
        self.imageData = entityRepresentation.values["image"] as? Data
        self.timer = entityRepresentation.values["timer"] as? Int
        self.order = order
    }
    
    func encode() -> EntityRepresentation {
        let values: [String : Any] = [
            "id" : self.id,
            "title" : self.title as Any,
            "texto" : self.texto as Any,
            "tip" : self.tip as Any,
            "timer" : self.timer as Any,
            "image" : self.imageData as Any,
            "order" : self.order as Any
        ]
        
        let toManyRelationships: [String : [EntityRepresentation]] = [:]
        
        let toOneRelationships: [String : EntityRepresentation] = [:]
        
        return EntityRepresentation(id: self.id, entityName: "StepEntity", values: values, toOneRelationships: toOneRelationships, toManyRelationships: toManyRelationships)
    }
}
