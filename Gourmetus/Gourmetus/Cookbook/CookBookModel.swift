//
//  CookBookModel.swift
//  Gourmetus
//
//  Created by Lucas Cunha on 24/10/23.
//

import Foundation

struct CookBookModel {
    var favorites: [RecipeModel]
    var latest: [RecipeModel]
    
    mutating func addFavorite(recipe:RecipeModel){
        favorites.append(recipe)
    }
    
    mutating func removeFavorite(recipe:RecipeModel){
        for i in 0...favorites.count {
            if (favorites[i].name == recipe.name){
                favorites.remove(at: i)
            }
        }
    }
    
}

