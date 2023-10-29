//
//  StepModel.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 24/10/23.
//

import Foundation
import CoreData

struct StepModel: Identifiable {
    var id: UUID
    var text: String?
    var tip: String?
    var imageData: Data?
    var timer: Float?
}

extension StepModel: CoreDataCodable {
    init?(_ entity: Step) {
        guard let id = entity.id else { return nil }
        
        self.id = id
        self.text = entity.text
        self.tip = entity.tip
        self.imageData = entity.image
        // if timer is default core data value, it should be nil
        self.timer = entity.timer == 0 ? nil : entity.timer
        
        return nil
    }
    
    func encode(context: NSManagedObjectContext, existingEntity: Step?) -> Step {
        let entity = existingEntity != nil ? existingEntity! : Step(context: context)
        
        entity.id = self.id
        entity.text = self.text
        entity.tip = self.tip
        entity.image = self.imageData
        entity.timer = self.timer ?? 0
        
        return entity
    }
}
