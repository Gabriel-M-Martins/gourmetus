//
//  RecipePlayerViewModel.swift
//  Gourmetus
//
//  Created by Eduardo Dalencon on 30/10/23.
//

import Foundation

class RecipePlayerViewModel: ObservableObject {
    @Published var recipe: RecipeModel
    @Published var currentStep: StepModel
    @Published var currentStepIndex: Int
    
    init(recipe: RecipeModel, initialStepIndex: Int? = nil) {
            self.recipe = recipe
            if let initialIndex = initialStepIndex {
                self.currentStepIndex = initialIndex
                self.currentStep = recipe.steps[initialIndex]
            } else {
                self.currentStepIndex = 0 // Default to 0 if no index is provided
                self.currentStep = recipe.steps[0]
            }
            
        }
    
    func nextStep(){
        if(currentStepIndex < recipe.steps.count - 1){
            self.currentStepIndex += 1
            currentStep = recipe.steps[currentStepIndex]
        }
        
        
    }
    
    func previousStep(){
        if(currentStepIndex > 0){
            self.currentStepIndex -= 1
            currentStep = recipe.steps[currentStepIndex]
        }
    }
}
