//
//  RecipeCardVerticalBigViewModel.swift
//  Gourmetus
//
//  Created by Thiago Defini on 07/11/23.
//

import Foundation

class RecipeCardVerticalBigViewModel: ObservableObject {
    
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
            print("Removendo dos favoritos")
            favoritesAux.remove(recipe)
        } else {
            print("Adicionando nos favoritos")
            favoritesAux.insert(recipe)
        }
        return Array(favoritesAux)
        
    }
    
}
