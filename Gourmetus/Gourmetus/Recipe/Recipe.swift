//
//  Recipe.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 24/10/23.
//

import Foundation
import CoreData

struct Recipe: Identifiable, Hashable{
    var id: UUID
    var name: String
    var desc: String?
    var difficulty: Int
    var imageData: Data?
    
    var steps: [Step]
    var ingredients: [Ingredient]
    
    
    init(id: UUID, name: String, desc: String? = nil, difficulty: Int, imageData: Data? = nil, steps: [Step], ingredients: [Ingredient]) {
        self.id = id
        self.name = name
        self.desc = desc
        self.difficulty = difficulty
        self.imageData = imageData
        self.steps = steps
        
        self.ingredients = ingredients
        self.ingredients.sort(by: { $0.name.lowercased() < $1.name.lowercased() } )
    }
}