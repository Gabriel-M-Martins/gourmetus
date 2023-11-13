//
//  RecipeDetailsViewModel.swift
//  Gourmetus
//
//  Created by Thiago Defini on 25/10/23.
//

import Foundation
import SwiftUI

class RecipeDetailsViewModel: ObservableObject{
    @Published var recipe: Recipe
    
    var isFavorite: Bool = false
    var cookbook: Cookbook = Cookbook()
    
    let menuOptions: [MenuOption] = [
        .Edit,
        .Delete
    ]
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    func populateCookbook(cookbook: Cookbook) {
        self.cookbook = cookbook
        self.isFavorite = cookbook.favorites.contains(where: { $0.id == recipe.id })
    }
    
    func toggleFavourite() {
        if isFavorite {
            cookbook.favorites.removeAll(where: { $0.id == recipe.id })
        } else {
            cookbook.favorites.append(recipe)
        }
        
        isFavorite.toggle()
    }
    
    func menuButtonClicked(_ option: MenuOption) {
        switch option {
        case .Duplicate:
            break
        case .Edit:
            break
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
