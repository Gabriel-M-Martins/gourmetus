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
    
    func editField(ingredient: IngredientModel){
        ingredientName = ingredient.name
        ingredientQuantity = ingredient.quantity
        ingredientUnit = ingredient.unit
    }
    
    func addIngredient(recipeViewModel: CreateEditRecipeViewModel){
        
        recipeViewModel.ingredients.append(IngredientModel(id: UUID() ,name: ingredientName, quantity: ingredientQuantity, unit: ingredientUnit))
       
        ingredientName = ""
        ingredientQuantity = ""
        ingredientUnit = .Kg
        
        recipeViewModel.editingIngredient = nil
    }
    
    func updateIngredient(recipeViewModel: CreateEditRecipeViewModel, ingredient: IngredientModel) {
        if let index = recipeViewModel.ingredients.firstIndex(of: ingredient) {
            recipeViewModel.ingredients[index] = IngredientModel(id: ingredient.id, name: ingredientName, quantity: ingredientQuantity, unit: ingredientUnit)
            ingredientName = ""
            ingredientQuantity = ""
            ingredientUnit = .Kg
        
        }
        recipeViewModel.editingIngredient = nil
    }
}
