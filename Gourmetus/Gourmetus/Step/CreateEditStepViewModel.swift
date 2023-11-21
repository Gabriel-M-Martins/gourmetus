//
//  CreateEditStepViewModel.swift
//  Gourmetus
//
//  Created by Eduardo Dalencon on 30/10/23.
//

import Foundation
import SwiftUI

protocol CreateEditStepDelegate {
    var editingStep: Step? { get }
    var imageData: UIImage? { get }
}

class CreateEditStepViewModel: ObservableObject {
    @Published var texto = ""
    @Published var tip = ""
    @Published var title = "Step Title"
    @Published var totalTime: Int? = 0
    @Published var ingredientsAdded: Set<Ingredient> = []
    @Published var menu = ["Image" : false, "Text": false, "Tip": false, "Timer": false]
    
    var delegate: CreateEditStepDelegate?
    
    func save(_ recipe: Recipe) {
        var step = delegate?.editingStep ?? Step()
        
        step.texto = (self.texto.isEmpty ? (step.texto ?? nil) : self.texto)
        step.tip = (self.tip.isEmpty ? (step.tip ?? nil) : self.tip)
        step.timer = totalTime
        step.imageData = delegate?.imageData?.pngData()
        step.ingredients = Array(ingredientsAdded)
        
        // TODO: Faltou lidar com a ordenação dos passos!!!
        if let idx = recipe.steps.firstIndex(where: { $0.id == step.id }) {
            step.order = idx
            recipe.steps[idx] = step
        } else {
            step.order = recipe.steps.count
            recipe.steps.append(step)
        }
    }
    
    func editField(step: Step){
        texto = step.texto ?? ""
        tip = step.tip  ?? ""
        title = step.title
        
        if let tempo = step.timer{
            totalTime = tempo
        }
    }
    
    func toggleIngredient(ingredient: Ingredient){
        if(ingredientsAdded.contains(ingredient)){
            ingredientsAdded.remove(ingredient)
        } else{
            ingredientsAdded.insert(ingredient)
        }
    }

}
