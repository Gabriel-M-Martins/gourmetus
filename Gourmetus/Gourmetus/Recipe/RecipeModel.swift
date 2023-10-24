//
//  RecipeModel.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 24/10/23.
//

import Foundation

struct RecipeModel {
    var name: String
    var desc: String?
    var difficulty: Float
    var imageData: Data?
    
    var steps: [StepModel]
    var ingredients: [IngredientModel]
}
