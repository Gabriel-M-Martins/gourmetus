//
//  Recipe.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 24/10/23.
//

import Foundation
import CoreData

final class Recipe: Identifiable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: UUID
    var name: String
    var desc: String?
    var difficulty: Int
    var rating: Float
    var imageData: Data?
    var duration: Int
    
    var steps: [Step]
    var ingredients: [Ingredient]
    var tags: [Tag]
    
    
    required init(id: UUID = UUID(), name: String = "", desc: String? = nil, difficulty: Int = 0, imageData: Data? = nil, steps: [Step] = [], ingredients: [Ingredient] = [], tags: [Tag] = [], duration: Int = 0) {
        self.id = id
        self.name = name
        self.desc = desc
        self.difficulty = difficulty
        self.rating = 0
        self.imageData = imageData
        self.duration = duration
        
        self.steps = steps
        
        self.ingredients = ingredients
        self.ingredients.sort(by: { $0.name.lowercased() < $1.name.lowercased() } )
        
        self.tags = tags
    }
}
