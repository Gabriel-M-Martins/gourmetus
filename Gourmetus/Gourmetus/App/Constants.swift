//
//  Constants.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 24/10/23.
//

import Foundation
import UIKit

struct Constants {
    static let mockedSteps: [Step] = [
        Step(id: UUID(), texto: "No liquidificador, bata os ovos, a margarina derretida, o leite e o açúcar.", tip: "Use um liquidificador.", imageData: UIImage(named: "DefaultRecipeImage")!.pngData(), order: 0 ),
        Step(id: UUID(), texto: "passo 2", order: 1),
        Step(id: UUID(), texto: "passo 3", order: 2),
        Step(id: UUID(), timer: 10, order: 3),
        Step(id: UUID(), texto: "passo 4", order: 4)
    ]
    
    static let mockedIngredients: [Ingredient] = [
        Ingredient(id: UUID(), name: "Farinha", quantity: "0.5", unit: .Kg),
        Ingredient(id: UUID(), name: "Ovo", quantity: "3", unit: .L),
        Ingredient(id: UUID(), name: "Sal", quantity: "10", unit: .G),
        Ingredient(id: UUID(), name: "Açucar", quantity: "2", unit: .Cup)
    ]
    
    static let mockedRecipe: Recipe = Recipe(id: UUID(),name: "Bolo Formigueiro", desc: "Bolo tri bom, vapo", difficulty: 3,steps: Self.mockedSteps, ingredients: Self.mockedIngredients)
    
    static let mockedRecipe1: Recipe = Recipe(id: UUID(),name: "Bala de banana", difficulty: 4,steps: Self.mockedSteps, ingredients: Self.mockedIngredients)

    static let mockedRecipe2: Recipe = Recipe(id: UUID(),name: "Brigadeiro", difficulty: 1,steps: Self.mockedSteps, ingredients: Self.mockedIngredients)

    static let mockedRecipeArray: [Recipe] = [mockedRecipe,mockedRecipe1,mockedRecipe2]
}
