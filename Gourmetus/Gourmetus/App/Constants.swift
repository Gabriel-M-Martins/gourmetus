//
//  Constants.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 24/10/23.
//

import Foundation
import UIKit

struct Constants {
    static let mockedSteps1: [Step] = [
        Step(id: UUID(), title: "passo 1", texto: "No liquidificador, bata os ovos, a margarina derretida, o leite e o açúcar.", tip: "Use um liquidificador.", imageData: UIImage(named: "banner-placeholder")!.pngData(), order: 0 ),
        Step(id: UUID(), title: "passo 2", texto: "passo 2", order: 1),
        Step(id: UUID(), title: "passo 3", texto: "passo 3", order: 2),
        Step(id: UUID(), title: "passo 4", timer: 10, order: 3),
        Step(id: UUID(), title: "passo 5", texto: "passo 4", imageData: UIImage(named: "Knife")?.pngData(), order: 4)
    ]
    
    static let mockedSteps2: [Step] = [
        Step(id: UUID(), title: "passo 1", texto: "No liquidificador, bata os ovos, a margarina derretida, o leite e o açúcar.", tip: "Use um liquidificador.", imageData: UIImage(named: "banner-placeholder")!.pngData(), order: 0 ),
        Step(id: UUID(), title: "passo 2", texto: "passo 2", order: 1),
        Step(id: UUID(), title: "passo 3", texto: "passo 3", order: 2),
        Step(id: UUID(), title: "passo 4", timer: 10, order: 3),
        Step(id: UUID(), title: "passo 5", texto: "passo 4", imageData: UIImage(named: "Knife")?.pngData(), order: 4)
    ]
    
    static let mockedSteps3: [Step] = [
        Step(id: UUID(), title: "passo 1", texto: "No liquidificador, bata os ovos, a margarina derretida, o leite e o açúcar.", tip: "Use um liquidificador.", imageData: UIImage(named: "banner-placeholder")!.pngData(), order: 0 ),
        Step(id: UUID(), title: "passo 2", texto: "passo 2", order: 1),
        Step(id: UUID(), title: "passo 3", texto: "passo 3", order: 2),
        Step(id: UUID(), title: "passo 4", timer: 10, order: 3),
        Step(id: UUID(), title: "passo 5", texto: "passo 4", imageData: UIImage(named: "Knife")?.pngData(), order: 4)
    ]
    
    static let mockedIngredients1: [Ingredient] = [
        Ingredient(id: UUID(), name: "Farinha", quantity: "0.5", unit: .Kg),
        Ingredient(id: UUID(), name: "Ovo", quantity: "3", unit: .L),
        Ingredient(id: UUID(), name: "Sal", quantity: "10", unit: .G),
        Ingredient(id: UUID(), name: "Açucar", quantity: "2", unit: .Cup)
    ]
    
    static let mockedIngredients2: [Ingredient] = [
        Ingredient(id: UUID(), name: "Farinha", quantity: "0.5", unit: .Kg),
        Ingredient(id: UUID(), name: "Ovo", quantity: "3", unit: .L),
        Ingredient(id: UUID(), name: "Sal", quantity: "10", unit: .G),
        Ingredient(id: UUID(), name: "Açucar", quantity: "2", unit: .Cup)
    ]
    
    static let mockedIngredients3: [Ingredient] = [
        Ingredient(id: UUID(), name: "Farinha", quantity: "0.5", unit: .Kg),
        Ingredient(id: UUID(), name: "Ovo", quantity: "3", unit: .L),
        Ingredient(id: UUID(), name: "Sal", quantity: "10", unit: .G),
        Ingredient(id: UUID(), name: "Açucar", quantity: "2", unit: .Cup)
    ]
    
    static let mockedTags: [Tag] = [
        Tag(name: "Mexican"),
        Tag(name: "Japanese"),
        Tag(name: "Italian"),
        Tag(name: "Korean"),
        Tag(name: "French"),
        Tag(name: "Brazillian"),
        Tag(name: "For You"),
        Tag(name: "For the Couple"),
        Tag(name: "For the Family"),
        Tag(name: "For the Friend Group"),
        Tag(name: "Fried"),
        Tag(name: "Boiled"),
        Tag(name: "Roasted"),
        Tag(name: "Cooked"),
        Tag(name: "Gluten Free"),
        Tag(name: "Lactose Free"),
        Tag(name: "Sodium Free"),
        Tag(name: "Sugar Free"),
        Tag(name: "Fat Free"),
        Tag(name: "Low Fat"),
        Tag(name: "Low Sodium"),
        Tag(name: "Low Sugar"),
        Tag(name: "Low Fat"),
        Tag(name: "Vegetarian"),
        Tag(name: "Vegan"),
        Tag(name: "Contains Alcohol"),
    ]
    
    static let mockedRecipe: Recipe = Recipe(id: UUID(),name: "Bolo Formigueiro", desc: "Bolo tri bom, vapo", difficulty: 3, steps: Self.mockedSteps1, ingredients: Self.mockedIngredients1, tags: [ mockedTags[4], mockedTags[5], mockedTags[6]], duration: 300)
    
    static let mockedRecipe1: Recipe = Recipe(id: UUID(),name: "Bala de banana", difficulty: 4,steps: Self.mockedSteps2, ingredients: Self.mockedIngredients2, tags: [ mockedTags[0], mockedTags[1], mockedTags[3]], duration: 300)

    static let mockedRecipe2: Recipe = Recipe(id: UUID(),name: "Brigadeiro de chocolate branco nadnsndasnhguyguguyguygdnasdnasndas", difficulty: 1, steps: Self.mockedSteps3, ingredients: Self.mockedIngredients3, tags: [ mockedTags[7], mockedTags[8], mockedTags[9]], duration: 300)

    static let mockedRecipes: [Recipe] = [mockedRecipe, mockedRecipe1, mockedRecipe2]
    
    
    static let mockedCookbook: Cookbook = Cookbook(id: UUID(), ownedRecipes: [mockedRecipe,mockedRecipe1,mockedRecipe2], favorites: [mockedRecipe,mockedRecipe1,mockedRecipe2], history: [mockedRecipe,mockedRecipe1,mockedRecipe2], community: [mockedRecipe,mockedRecipe1,mockedRecipe2])
    
    static let mockedCookbookEmpty: Cookbook = Cookbook()
    
}
