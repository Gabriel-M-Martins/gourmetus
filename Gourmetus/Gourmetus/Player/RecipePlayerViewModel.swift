//
//  RecipePlayerViewModel.swift
//  Gourmetus
//
//  Created by Eduardo Dalencon on 30/10/23.
//

import Foundation

protocol PlayerDelegate {
    var cookbook: Cookbook { get }
}

class RecipePlayerViewModel: ObservableObject {
    @Published var recipe: Recipe
    @Published var currentStep: Step
    @Published var currentStepIndex: Int
    
    var delegate: PlayerDelegate?
    
    @Injected private var repo: any Repository<Recipe>
   
    
    init(recipe: Recipe, initialStepIndex: Int? = nil) {
            self.recipe = recipe
            if let initialIndex = initialStepIndex {
                self.currentStepIndex = initialIndex
                self.currentStep = recipe.steps[initialIndex]
            } else {
                self.currentStepIndex = 0 // Default to 0 if no index is provided
                self.currentStep = recipe.steps[0]
            }
            
        }
    
    func nextStep() {
        if(currentStepIndex < recipe.steps.count - 1){
            self.currentStepIndex += 1
            currentStep = recipe.steps[currentStepIndex]
        }
    }
    
    func previousStep() {
        if(currentStepIndex > 0){
            self.currentStepIndex -= 1
            currentStep = recipe.steps[currentStepIndex]
        }
 
    }
    
    func firstStep() {
        if(currentStepIndex != 0){
            self.currentStepIndex = 0
            currentStep = recipe.steps[currentStepIndex]
        }
    }
    
    func lastStep() {
        if(currentStepIndex < recipe.steps.count - 1){
            self.currentStepIndex = recipe.steps.count - 1
            currentStep = recipe.steps[currentStepIndex]
        }
    }
    
    func concatenateIngredients() -> String {
        guard !currentStep.ingredients.isEmpty else { return "None" }

        if currentStep.ingredients.count == 1 {
            return currentStep.ingredients[0].name
        }
        
        var result = ""
        
        for (index, ingredient) in currentStep.ingredients.enumerated() {
            if index == currentStep.ingredients.count - 1 {
                   result += "and \(ingredient.name)"
            } else {
                   result += "\(ingredient.name), "
            }
        }

           return result
       }
    
    func completeRecipe(){
        recipe.completed = true
        delegate?.cookbook.addLatest(recipe: recipe)
    }
}
