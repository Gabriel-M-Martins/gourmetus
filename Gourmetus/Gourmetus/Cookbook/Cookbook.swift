//
//  Cookbook.swift
//  Gourmetus
//
//  Created by Lucas Cunha on 24/10/23.
//

import Foundation
import CoreData

final class Cookbook: Hashable, ObservableObject {
    @Injected private var repo: any Repository<Cookbook>
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func == (lhs: Cookbook, rhs: Cookbook) -> Bool {
        lhs.id == rhs.id
    }
    
    @Published var id: UUID
    @Published var ownedRecipes: [Recipe]
    @Published var favorites: [Recipe]
    @Published var history: [Recipe]
    @Published var community: [Recipe]
    @Published private var latestSize = 10
    
    required init(id: UUID = UUID(), ownedRecipes: [Recipe] = [], favorites: [Recipe] = [], history: [Recipe] = [], community: [Recipe] = [], latestSize: Int = 10) {
        self.id = id
        self.ownedRecipes = ownedRecipes
        self.favorites = favorites
        self.history = history
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
    
    func fetch() {
        guard let cookbook = repo.fetch().first else {
            self.id = UUID()
            self.ownedRecipes = Constants.mockedRecipes
            self.favorites = Constants.mockedRecipes
            self.history = Constants.mockedRecipes
            self.community = Constants.mockedRecipes
            
            return
        }
        
        self.id = cookbook.id
        self.ownedRecipes = cookbook.ownedRecipes
        self.favorites = cookbook.favorites
        self.history = cookbook.history
        self.community = cookbook.community
    }
    
    func fetch(id: UUID) {
        guard let cookbook = repo.fetch(id: id) else { return }
        
        self.id = cookbook.id
        self.ownedRecipes = cookbook.ownedRecipes
        self.favorites = cookbook.favorites
        self.history = cookbook.history
        self.community = cookbook.community
    }
    
    func addFavorite(recipe: Recipe) {
        favorites.append(recipe)
    }
    
    func removeFavorite(recipe: Recipe){
        for i in 0..<favorites.count {
            if (favorites[i].id == recipe.id){
                favorites.remove(at: i)
            }
        }
    }
    
    func removeOwned(recipe: Recipe) {
        for i in 0..<ownedRecipes.count {
            if (ownedRecipes[i].id == recipe.id){
                ownedRecipes.remove(at: i)
            }
        }
    }
    
    @discardableResult
    func toggleFavourite(recipe: Recipe) -> Bool {
        if self.favorites.contains(where: { $0.id == recipe.id }) {
            self.favorites.removeAll(where: { $0.id == recipe.id })
            return false
        } else {
            self.favorites.append(recipe)
            return true
        }
    }
    
    func isFavoritedRecipe(recipe: Recipe) -> Bool {
        self.favorites.contains(where: { $0.id == recipe.id })
    }
    
    func addLatest(recipe: Recipe){
        if(history.count == latestSize){
            history.remove(at: latestSize)
        }
            history.append(recipe)
//        latest.sort(by: $0.date.compare($1.date) == orderedAscending)
    }
    
    
}
