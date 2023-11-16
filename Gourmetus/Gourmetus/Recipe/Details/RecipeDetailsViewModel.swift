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
        case .Duplicate:
            break
        case .Edit:
            delegate?.editRecipe()
        case .Delete:
            break
        case .Report:
            break
        }
    }
    
    enum MenuOption: CaseIterable {
        case Duplicate
        case Edit
        case Delete
        case Report
        
        var description: String {
            switch self {
            case .Duplicate:
                return "Duplicate"
            case .Edit:
                return "Edit"
            case .Delete:
                return "Delete"
            case .Report:
                return "Report"
            }
        }
        
        var isDestructive: Bool {
            switch self {
            case .Duplicate:
                return false
            case .Edit:
                return false
            case .Delete:
                return true
            case .Report:
                return true
            }
        }
    }
}
