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
    private var latestSize = 10
    
    init(favorites: [RecipeModel], latest: [RecipeModel], latestSize: Int = 10) {
        self.favorites = favorites
        self.latest = latest
        self.latestSize = latestSize
    }
    
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
    
    mutating func addLatest(recipe:RecipeModel){
        if(latest.count == latestSize){
            latest.remove(at: latestSize)
        }
            latest.append(recipe)
//        latest.sort(by: $0.date.compare($1.date) == orderedAscending)
    }
    
    
}

//        var f = Date.now
//        var b = Date.now
//        switch b.compare(f){
//        case .orderedAscending:
//            break
//        }
        
//        latest.sort(by: $0.date.compare($1.date) == orderedAscending)
