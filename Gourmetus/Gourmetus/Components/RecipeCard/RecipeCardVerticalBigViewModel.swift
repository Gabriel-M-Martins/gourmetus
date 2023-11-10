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

    func toggleFavourite(favorites: [Recipe]) -> [Recipe] {
        var favoritesAux = favorites
        if self.isFavorite(favorites: favorites){
            print("Removendo dos favoritos")
            for i in 0..<favorites.count {
                if favorites[i].id == recipe.id {
                    favoritesAux.remove(at: i)
                    break
                }
            }
            return favoritesAux
        } else {
            print("Adicionando nos favoritos")
            favoritesAux.append(recipe)
            return favoritesAux
        }
    }
}
