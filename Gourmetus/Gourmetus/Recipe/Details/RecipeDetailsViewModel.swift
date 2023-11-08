//
//  RecipeDetailsViewModel.swift
//  Gourmetus
//
//  Created by Thiago Defini on 25/10/23.
//

import Foundation

class RecipeDetailsViewModel: ObservableObject{
    @Published var recipe: Recipe
    
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
    
}
