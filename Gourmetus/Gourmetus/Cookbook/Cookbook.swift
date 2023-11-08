//
//  Cookbook.swift
//  Gourmetus
//
//  Created by Lucas Cunha on 24/10/23.
//

import Foundation
import CoreData

struct Cookbook : Hashable{
    var id: UUID
    var favorites: [Recipe]
    var history: [Recipe]
    private var latestSize = 10
    
    init(id: UUID, favorites: [Recipe], latest: [Recipe], latestSize: Int = 10) {
        self.id = id
        self.favorites = favorites
        self.history = latest
        self.latestSize = latestSize
    }
    
    mutating func addFavorite(recipe: Recipe) {
        favorites.append(recipe)
    }
    
    mutating func removeFavorite(recipe: Recipe){
        for i in 0...favorites.count {
            if (favorites[i].name == recipe.name){
                favorites.remove(at: i)
            }
        }
        
    }
    
    mutating func addLatest(recipe: Recipe){
        if(history.count == latestSize){
            history.remove(at: latestSize)
        }
            history.append(recipe)
//        latest.sort(by: $0.date.compare($1.date) == orderedAscending)
    }
    
    
}
