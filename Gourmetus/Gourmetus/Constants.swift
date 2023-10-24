//
//  Constants.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 24/10/23.
//

import Foundation

struct Constants {
    static let mockedSteps: [StepModel] = [
        StepModel(text: "passo 1"),
        StepModel(text: "passo 2"),
        StepModel(text: "passo 3"),
        StepModel(timer: 30),
        StepModel(text: "passo 4")
    ]
    
    static let mockedIngredients: [IngredientModel] = [
        IngredientModel(name: "Farinha", quantity: "0.5", unit: .Kg),
        IngredientModel(name: "Ovo", quantity: "3", unit: .L),
        IngredientModel(name: "Sal", quantity: "10", unit: .G),
        IngredientModel(name: "Açucar", quantity: "2", unit: .Cup)
    ]
    
    static let mockedRecipe: RecipeModel = RecipeModel(name: "Bolo Formigueiro", difficulty: 3, steps: Self.mockedSteps, ingredients: Self.mockedIngredients)
}
