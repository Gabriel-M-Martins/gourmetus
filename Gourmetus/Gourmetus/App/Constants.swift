//
//  Constants.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 24/10/23.
//

import Foundation
import UIKit

struct Constants {
    static let mockedSteps: [StepModel] = [
        StepModel(id: UUID(), texto: "No liquidificador, bata os ovos, a margarina derretida, o leite e o açúcar.", tip: "Use um liquidificador.", imageData: UIImage(named: "DefaultRecipeImage")!.pngData() ),
        StepModel(id: UUID(), texto: "passo 2"),
        StepModel(id: UUID(), texto: "passo 3"),
        StepModel(id: UUID(), timer: 30),
        StepModel(id: UUID(), texto: "passo 4")
    ]
    
    static let mockedIngredients: [IngredientModel] = [
        IngredientModel(id: UUID(), name: "Farinha", quantity: "0.5", unit: .Kg),
        IngredientModel(id: UUID(), name: "Ovo", quantity: "3", unit: .L),
        IngredientModel(id: UUID(), name: "Sal", quantity: "10", unit: .G),
        IngredientModel(id: UUID(), name: "Açucar", quantity: "2", unit: .Cup)
    ]
    
    static let mockedRecipe: RecipeModel = RecipeModel(id: UUID(),name: "Bolo Formigueiro", desc: "Bolo tri bom, vapo", difficulty: 3,steps: Self.mockedSteps, ingredients: Self.mockedIngredients)
    
    static let mockedRecipe1: RecipeModel = RecipeModel(id: UUID(),name: "Bala de banana", difficulty: 4,steps: Self.mockedSteps, ingredients: Self.mockedIngredients)

    static let mockedRecipe2: RecipeModel = RecipeModel(id: UUID(),name: "Brigadeiro", difficulty: 1,steps: Self.mockedSteps, ingredients: Self.mockedIngredients)

    static let mockedRecipeArray: [RecipeModel] = [mockedRecipe,mockedRecipe1,mockedRecipe2]
}
