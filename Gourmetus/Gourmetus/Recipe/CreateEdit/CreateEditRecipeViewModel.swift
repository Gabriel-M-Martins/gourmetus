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
    @Published var ingredients: [Ingredient] = []
    @Published var steps: [Step] = []
    @Published var image: UIImage = UIImage()
    @Published var isAddingIngredient = false
    @Published var ingredientName = ""
    @Published var ingredientQuantity = ""
    @Published var ingredientUnit : IngredientUnit = .Kg
    @Published var ingredientsBeingEdited: [Ingredient] = []
    @Published var hourSelection = 0
    @Published var minuteSelection = 0
    
    @Published var editingStep: Step?
    @Published var editingIngredient: Ingredient?
    
    @Injected private var repo: any Repository<Recipe>
    
    func addIngredient(){
        ingredients.append(Ingredient(id: UUID() ,name: ingredientName, quantity: ingredientQuantity, unit: ingredientUnit))
        isAddingIngredient = false
        ingredientName = ""
        ingredientQuantity = ""
        ingredientUnit = .Kg
    }
    
    func saveRepo(recipe: Recipe?){
        
        var calculatedDuration = hourSelection * 60 + minuteSelection
      
        if (recipe != nil){
            let rec = Recipe(id: recipe!.id, name: recipeTitle, difficulty: difficulty, steps: steps, ingredients: ingredients, duration: calculatedDuration)
            repo.save(rec)
            print(repo.fetch(id: recipe!.id))
        } else {
            let rec = Recipe(id: UUID(), name: recipeTitle, difficulty: difficulty, steps: steps, ingredients: ingredients, duration: calculatedDuration)
            repo.save(rec)
        }
    }
    
    func deleteIngredient(ingredient: Ingredient){
        if let index = ingredients.firstIndex(of: ingredient) {
            ingredients.remove(at: index)
                    }
    }
    
    func deleteStep(step: Step){
        if let index = steps.firstIndex(of: step) {
            steps.remove(at: index)
                    }
    }
    
    func toggleIngredientEditing(ingredient: Ingredient){
        ingredientName = ingredient.name
        ingredientQuantity = ingredient.quantity
        ingredientUnit = ingredient.unit
        
        ingredientsBeingEdited.append(ingredient)
        
        
    }
    
    func swapWithNext(step: Step) {
        if let index = steps.firstIndex(of: step) {
            guard index < steps.count - 1 else { return } // Ensure there is a next item to swap with.
            
            steps.swapAt(index, index + 1)
            
                    }
            
        }
    
    func swapWithPrevious(step: Step) {
        if let index = steps.firstIndex(of: step) {
            guard index > 0 else { return } // Ensure there is a previous item to swap with.

            steps.swapAt(index, index - 1)
        }
    }

    
    func updateIngredient(ingredient: Ingredient) {
        if let index = ingredients.firstIndex(of: ingredient) {
            
            if let indexEdited = ingredientsBeingEdited.firstIndex(of: ingredient) {
                ingredientsBeingEdited.remove(at: indexEdited)
                        }
            ingredients[index] = Ingredient(id: ingredient.id, name: ingredientName, quantity: ingredientQuantity, unit: ingredientUnit)
            ingredientName = ""
            ingredientQuantity = ""
            ingredientUnit = .Kg
            
            
            
        }
    }
    
    func editRecipe(recipe: Recipe){
        recipeTitle = recipe.name
        desc = recipe.desc ?? ""
        ingredients = recipe.ingredients
        steps = recipe.steps
        difficulty = recipe.difficulty
        hourSelection = recipe.duration / 60
        minuteSelection = recipe.duration % 60
        print(recipe.duration)
        
    }
}
