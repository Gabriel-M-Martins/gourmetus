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
    
    let menuOptions: [MenuOption] = [
        .Edit,
        .Delete
    ]
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    func isFavorite(favorites: [Recipe]) -> Bool{
        for favorite in favorites{
            if favorite.id == recipe.id{
                return true
            }
        }
        return false
    }

    func toggleFavourite(recipe: Recipe, favorites: [Recipe]) -> [Recipe]{
        var favoritesAux = Set(favorites)
        if self.isFavorite(favorites: favorites){
            favoritesAux.remove(recipe)
        } else {
            favoritesAux.insert(recipe)
        }
        return Array(favoritesAux)
        
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
