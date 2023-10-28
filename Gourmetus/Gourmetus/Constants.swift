//
//  Constants.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 24/10/23.
//

import Foundation

struct Constants {
    static let mockedSteps: [StepModel] = [
        StepModel(id: UUID(), text: "passo 1"),
        StepModel(id: UUID(), text: "passo 2"),
        StepModel(id: UUID(), text: "passo 3"),
        StepModel(id: UUID(), timer: 30),
        StepModel(id: UUID(), text: "passo 4")
    ]
    
    static let mockedIngredients: [IngredientModel] = [
        IngredientModel(id: UUID(), name: "Farinha", quantity: "0.5", unit: .Kg),
        IngredientModel(id: UUID(), name: "Ovo", quantity: "3", unit: .L),
        IngredientModel(id: UUID(), name: "Sal", quantity: "10", unit: .G),
        IngredientModel(id: UUID(), name: "Açucar", quantity: "2", unit: .Cup)
    ]
    
    static let mockedRecipe: RecipeModel = RecipeModel(id: UUID(), name: "Bolo Formigueiro", difficulty: 3, steps: Self.mockedSteps, ingredients: Self.mockedIngredients)
}
