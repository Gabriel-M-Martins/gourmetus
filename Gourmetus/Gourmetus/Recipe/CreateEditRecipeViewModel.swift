//
//  CreateEditRecipeViewModel.swift
//  Gourmetus
//
//  Created by Eduardo Dalencon on 30/10/23.
//

import Foundation
import SwiftUI

class CreateEditRecipeViewModel: ObservableObject {
    @Published var recipeTitle = ""
    @Published var desc = ""
    @Published var difficulty = 1
    @Published var ingredients: [IngredientModel] = []
    @Published var steps: [StepModel] = []
    @Published var image: UIImage = UIImage()
    @Published var isAddingIngredient = false
    @Published var ingredientName = ""
    @Published var ingredientQuantity = ""
    @Published var ingredientUnit : IngredientUnit = .Kg
    @Published var ingredientsBeingEdited: [IngredientModel] = []
    
    
    
    func addIngredient(){
        ingredients.append(IngredientModel(id: UUID() ,name: ingredientName, quantity: ingredientQuantity, unit: ingredientUnit))
        isAddingIngredient = false
        ingredientName = ""
        ingredientQuantity = ""
        ingredientUnit = .Kg
    }
    
    func deleteIngredient(ingredient: IngredientModel){
        if let index = ingredients.firstIndex(of: ingredient) {
            ingredients.remove(at: index)
                    }
    }
    
    func deleteStep(step: StepModel){
        if let index = steps.firstIndex(of: step) {
            steps.remove(at: index)
                    }
    }
    
    func toggleIngredientEditing(ingredient: IngredientModel){
        ingredientName = ingredient.name
        ingredientQuantity = ingredient.quantity
        ingredientUnit = ingredient.unit
        
        ingredientsBeingEdited.append(ingredient)
        
        
    }
    
    func swapWithNext(step: StepModel) {
        if let index = steps.firstIndex(of: step) {
            guard index < steps.count - 1 else { return } // Ensure there is a next item to swap with.
            
            steps.swapAt(index, index + 1)
            
                    }
            
        }
    
    func swapWithPrevious(step: StepModel) {
        if let index = steps.firstIndex(of: step) {
            guard index > 0 else { return } // Ensure there is a previous item to swap with.

            steps.swapAt(index, index - 1)
        }
    }

    
    func updateIngredient(ingredient: IngredientModel) {
        if let index = ingredients.firstIndex(of: ingredient) {
            
            if let indexEdited = ingredientsBeingEdited.firstIndex(of: ingredient) {
                ingredientsBeingEdited.remove(at: indexEdited)
                        }
            ingredients[index] = IngredientModel(id: ingredient.id, name: ingredientName, quantity: ingredientQuantity, unit: ingredientUnit)
            ingredientName = ""
            ingredientQuantity = ""
            ingredientUnit = .Kg
            
            
            
        }
    }
    
    func editRecipe(recipe: RecipeModel){
        recipeTitle = recipe.name
        desc = recipe.desc ?? ""
        ingredients = recipe.ingredients
        steps = recipe.steps
        difficulty = recipe.difficulty
        
    }
}
