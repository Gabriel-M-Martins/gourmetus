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
    
    @Published var id: UUID = UUID()
    @Published var ownedRecipes: [Recipe] = []
    @Published var favorites: [Recipe] = []
    @Published var history: [Recipe] = []
    @Published var community: [Recipe] = []
    
    private var historyMaxSize = 10
    
    required init(id: UUID = UUID(), ownedRecipes: [Recipe] = [], favorites: [Recipe] = [], history: [Recipe] = [], community: [Recipe] = [], historyMaxSize: Int = 10) {
        self.id = id
        self.ownedRecipes = ownedRecipes
        self.favorites = favorites
        self.history = history
        self.community = community
        self.historyMaxSize = historyMaxSize
    }
    
    init() {
        fetch()
    }
    
    func fetch() {
        if let cookbook = repo.fetch().first {
            self.id = cookbook.id
            self.ownedRecipes = cookbook.ownedRecipes
            self.favorites = cookbook.favorites
            self.history = cookbook.history
            self.community = cookbook.community
            
        } else {
            self.id = UUID()
            self.ownedRecipes = []
            self.favorites = []
            self.history = []
            self.community = []
        }
        
        DefaultRecipesUtility.fetch { [weak self] result in
            guard let self = self else { return }
            repo.delete(self)
            
            for recipe in result {
                if !self.community.contains(where: {$0.name == recipe.name}) {
                    self.community.append(recipe)
                }
            }
            
            repo.save(self)
        }
    }
    
    func fetch(id: UUID) {
        guard let cookbook = repo.fetch(id: id) else { return }
        
        self.id = cookbook.id
        self.ownedRecipes = cookbook.ownedRecipes
        self.favorites = cookbook.favorites
        self.history = cookbook.history
        self.community = cookbook.community
    }
    
    func removeOwned(recipe: Recipe) {
        for i in 0..<ownedRecipes.count {
            if (ownedRecipes[i].id == recipe.id) {
                ownedRecipes.remove(at: i)
            }
        }
    }
    
    @discardableResult
    func toggleFavourite(recipe: Recipe) -> Bool {
        let result: Bool
        if self.favorites.contains(where: { $0.id == recipe.id }) {
            self.favorites.removeAll(where: { $0.id == recipe.id })
            result = false
        } else {
            self.favorites.append(recipe)
            result = true
        }
        
        repo.save(self)
        return result
    }
    
    func isFavoritedRecipe(recipe: Recipe) -> Bool {
        self.favorites.contains(where: { $0.id == recipe.id })
    }
    
    func addToHistory(recipe: Recipe) {
        if history.contains(recipe) {
            return
        }
        
        if history.count == historyMaxSize {
            history.remove(at: historyMaxSize)
        }
        
        history.append(recipe)
        repo.save(self)
        //        latest.sort(by: $0.date.compare($1.date) == orderedAscending)
    }
}
