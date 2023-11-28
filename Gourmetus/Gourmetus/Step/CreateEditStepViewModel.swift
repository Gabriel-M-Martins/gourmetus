//
//  CreateEditStepViewModel.swift
//  Gourmetus
//
//  Created by Eduardo Dalencon on 30/10/23.
//

import Foundation
import SwiftUI

protocol CreateEditStepDelegate {
    var editingStep: Step { get }
//    var imageData: UIImage? { get }
    var imageSelected: UIImage? { get }
    var recipe: Recipe { get }
}

class CreateEditStepViewModel: ObservableObject {
    @Published var ingredientsAdded: Set<Ingredient> = []
    @Published var vector = ["Image" : false, "Text": false, "Tip": false, "Timer": false]
    
    var delegate: CreateEditStepDelegate?
    
    var texto: String {
        delegate?.editingStep.texto ?? ""
    }
    
    var tip: String {
        delegate?.editingStep.tip ?? ""
    }
    
    var timer: Int {
        delegate?.editingStep.timer ?? 0
    }
    
    var title: String {
        delegate?.editingStep.title ?? "Title"
    }
    
//    var image: Data? {
//        return delegate?.editingStep.imageData ?? nil
//    }
    
    var image: UIImage {
        var image: UIImage
        
        print(delegate == nil)
        
        if let tmp = delegate?.imageSelected {
            image = tmp
        } else if let tmpData = delegate?.editingStep.imageData {
            print("coe caralho \(tmpData)")
            if let tmp = UIImage(data: tmpData) {
                image = tmp
            } else {
                image = UIImage()
            }
        } else if let tmp = UIImage(systemName: "photo") {
            image = tmp
        } else {
            image = UIImage()
        }
        
        return image
    }
    
    var isEmptyState : Bool {
        !(vector.contains {$0.value == true}) && ingredientsAdded.isEmpty
    }
    
    func save() {
//        var step = delegate?.editingStep ?? Step()
        guard let step = delegate?.editingStep,
              let recipe = delegate?.recipe
        else {
            return
        }
        step.texto = (self.texto.isEmpty ? (step.texto ?? nil) : self.texto)
        step.tip = (self.tip.isEmpty ? (step.tip ?? nil) : self.tip)
        step.timer = timer
//        step.imageData = self.image.asUIImage().pngData()
        step.imageData = self.image.pngData()
        step.ingredients = Array(ingredientsAdded)
        
//      TODO: Faltou lidar com a ordenação dos passos!!!
        if let idx = recipe.steps.firstIndex(where: { $0.id == step.id }) {
            step.order = idx
            recipe.steps[idx] = step
        } else {
            step.order = recipe.steps.count
            recipe.steps.append(step)
        }
        
        print(step.title)
        print(recipe.steps.map({$0.title}))
    }
    
//    func editField(step: Step) {
//        texto = step.texto ?? ""
//        tip = step.tip  ?? ""
//        ingredientsAdded = Set(step.ingredients)
//        title = step.title
//        image = step.imageData
//        
//        if let tempo = step.timer {
//            totalTime = tempo
//        }
//    }
    
    func toggleIngredient(ingredient: Ingredient){
        if(ingredientsAdded.contains(ingredient)){
            ingredientsAdded.remove(ingredient)
        } else{
            ingredientsAdded.insert(ingredient)
        }
    }
    
    func setVisibility(){
        self.vector.updateValue(texto != "", forKey: "Text")
        self.vector.updateValue(tip != "", forKey: "Tip")
//        self.vector.updateValue(image != nil, forKey: "Image")
        self.vector.updateValue(delegate?.editingStep.imageData != nil, forKey: "Image")
        self.vector.updateValue(timer != 0, forKey: "Timer")
    }

}
