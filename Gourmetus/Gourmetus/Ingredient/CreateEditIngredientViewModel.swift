//
//  CreateEditIngredientViewModel.swift
//  Gourmetus
//
//  Created by Eduardo Dalencon on 10/11/23.
//

import Foundation

class CreateEditIngredientViewModel: ObservableObject {
    @Published var ingredientName = ""
    @Published var ingredientQuantity = ""
    @Published var ingredientUnit : IngredientUnit = .Kg
    
    func editField(ingredient: Ingredient){
        ingredientName = ingredient.name
        ingredientQuantity = ingredient.quantity
        ingredientUnit = ingredient.unit
    }
    
    func addIngredient(recipeViewModel: CreateEditRecipeViewModel){
        
        recipeViewModel.ingredients.append(Ingredient(id: UUID() ,name: ingredientName, quantity: ingredientQuantity, unit: ingredientUnit))
       
        ingredientName = ""
        ingredientQuantity = ""
        ingredientUnit = .Kg
        
        recipeViewModel.editingIngredient = nil
    }
    
    func updateIngredient(recipeViewModel: CreateEditRecipeViewModel, ingredient: Ingredient) {
        if let index = recipeViewModel.ingredients.firstIndex(of: ingredient) {
            recipeViewModel.ingredients[index] = Ingredient(id: ingredient.id, name: ingredientName, quantity: ingredientQuantity, unit: ingredientUnit)
            ingredientName = ""
            ingredientQuantity = ""
            ingredientUnit = .Kg
        
        }
        recipeViewModel.editingIngredient = nil
    }
}
