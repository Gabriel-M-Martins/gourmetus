//
//  CreateEditStepViewModel.swift
//  Gourmetus
//
//  Created by Eduardo Dalencon on 30/10/23.
//

import Foundation
import SwiftUI

class CreateEditStepViewModel: ObservableObject {
    @Published var texto = ""
    @Published var tip = ""
    @Published var title = ""
    @Published var totalTime: Int? = 0
    @Published var ingredientsAdded: Set<Ingredient> = []
    
    func addStep(viewModel: CreateEditRecipeViewModel, imageViewModel:PhotoPickerViewModel){
        if let imageData = imageViewModel.selectedImage!.jpegData(compressionQuality: 1.0) {
            viewModel.steps.append(Step(id: UUID(), title: "foo", texto: texto, tip: tip , imageData: imageData ,timer: totalTime, order: -1))
            imageViewModel.selectedImage = UIImage()
        } else {
            viewModel.steps.append(Step(id: UUID(), title: "bar", texto: texto, tip: tip ,timer: totalTime, order: -1))
        }
    }
    
    func editStep(viewModel: CreateEditRecipeViewModel, imageViewModel:PhotoPickerViewModel ,editingStep: Step){
        if let index = viewModel.steps.firstIndex(of: editingStep) {
            if (imageViewModel.selectedImage != nil) {
                let imageData = imageViewModel.selectedImage!.jpegData(compressionQuality: 1.0)
                viewModel.steps[index] = Step(id:editingStep.id, title: "foo1" ,texto: texto, tip: tip , imageData: imageData ,timer: totalTime, order: -1)
                imageViewModel.selectedImage = UIImage()
            } else{
                viewModel.steps[index] = Step(id:editingStep.id, title: "bar1", texto: texto, tip: tip ,timer: totalTime, order: -1)
            }
        }
    }
    
    func editField(step: Step){
        texto = step.texto ?? ""
        tip = step.tip  ?? ""
        title = step.title ?? ""
        
        if let tempo = step.timer{
            totalTime = tempo
        }
    }
    
    func addIngredient(ingredient: Ingredient){
        ingredientsAdded.insert(ingredient)
    }

}
