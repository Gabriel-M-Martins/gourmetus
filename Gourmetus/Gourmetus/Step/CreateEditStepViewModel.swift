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
    @Published var totalTime: Int? = 0
    
    func addStep(viewModel: CreateEditRecipeViewModel, imageViewModel:PhotoPickerViewModel){
        if let imageData = imageViewModel.selectedImage!.jpegData(compressionQuality: 1.0) {
            viewModel.steps.append(StepModel(texto: texto, tip: tip , imageData: imageData ,timer: totalTime))
            imageViewModel.selectedImage = UIImage()
        } else {
            viewModel.steps.append(StepModel(texto: texto, tip: tip ,timer: totalTime))
        }
    }
    
    func editStep(viewModel: CreateEditRecipeViewModel, imageViewModel:PhotoPickerViewModel ,editingStep: StepModel){
        if let index = viewModel.steps.firstIndex(of: editingStep) {
            if (imageViewModel.selectedImage != nil) {
                let imageData = imageViewModel.selectedImage!.jpegData(compressionQuality: 1.0)
                viewModel.steps[index] = StepModel(texto: texto, tip: tip , imageData: imageData ,timer: totalTime)
                imageViewModel.selectedImage = UIImage()
            } else{
                viewModel.steps[index] = StepModel(texto: texto, tip: tip ,timer: totalTime)
            }
        }
    }
    
    func editField(step: StepModel){
        texto = step.texto ?? ""
        tip = step.tip  ?? ""
        
        if let tempo = step.timer{
            totalTime = tempo
        }
    }

}
