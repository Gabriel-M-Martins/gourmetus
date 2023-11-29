//
//  RecipeDetailsViewModel.swift
//  Gourmetus
//
//  Created by Thiago Defini on 25/10/23.
//

import Foundation
import SwiftUI

protocol RecipeDetailsDelegate {
    func editRecipe()
    func deleteRecipe()
    func startRecipe()
}

class RecipeDetailsViewModel: ObservableObject{    
    var delegate: RecipeDetailsDelegate?
    
    let menuOptions: [MenuOption] = [
        .Edit,
        .Delete
    ]
    
//    func convertHoursMinutes() -> String{
//        return String(format: "%02d:%02d", self.recipe.duration/60, self.recipe.duration%60)
//    }
    
    func menuButtonClicked(_ option: MenuOption) {
        switch option {
        case .Edit:
            delegate?.editRecipe()
        case .Delete:
            // 1 - Deleta
            delegate?.deleteRecipe()
            break
        }
    }
    
    enum MenuOption: CaseIterable {
        case Edit
        case Delete
        
        var description: String {
            switch self {
            case .Edit:
                return "Edit"
            case .Delete:
                return "Delete"
            }
        }
        
        var isDestructive: Bool {
            switch self {
            case .Edit:
                return false
            case .Delete:
                return true
            }
        }
    }
    
//    func deleteRecipe(recipe: Recipe){
//        
//    }
}
