//
//  Cookbook.swift
//  Gourmetus
//
//  Created by Lucas Cunha on 24/10/23.
//

import Foundation
import CoreData

final class Cookbook: Hashable, ObservableObject{
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
    
    static func == (lhs: Cookbook, rhs: Cookbook) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: UUID
    var ownedRecipes: [Recipe]
    var favorites: [Recipe]
    var history: [Recipe]
    var community: [Recipe]
    private var latestSize = 10
    
    required init(id: UUID, ownedRecipes: [Recipe], favorites: [Recipe], latest: [Recipe], community: [Recipe], latestSize: Int = 10) {
        self.id = id
        self.ownedRecipes = ownedRecipes
        self.favorites = favorites
        self.history = latest
        self.community = community
        self.latestSize = latestSize
    }
    
    init(){
        self.id = UUID()
        self.ownedRecipes = []
        self.favorites = []
        self.history = []
        self.community = []
        self.latestSize = 10
    }
    
    func addFavorite(recipe: Recipe) {
        favorites.append(recipe)
    }
    
    func removeFavorite(recipe: Recipe){
        for i in 0...favorites.count {
            if (favorites[i].name == recipe.name){
                favorites.remove(at: i)
            }
        }
        
    }
    
    func addLatest(recipe: Recipe){
        if(history.count == latestSize){
            history.remove(at: latestSize)
        }
            history.append(recipe)
//        latest.sort(by: $0.date.compare($1.date) == orderedAscending)
    }
    
    
}
