//
//  CookBookModel.swift
//  Gourmetus
//
//  Created by Lucas Cunha on 24/10/23.
//

import Foundation
import CoreData

struct CookBookModel {
    var id: UUID
    var favorites: [RecipeModel]
    var latest: [RecipeModel]
    private var latestSize = 10
    
    init(id: UUID, favorites: [RecipeModel], latest: [RecipeModel], latestSize: Int = 10) {
        self.id = id
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


extension CookBookModel : CoreDataCodable {
    init?(_ entity: Cookbook) {
        guard let id = entity.id else { return nil }
        self.id = id
        
        self.favorites = []
        let favorites = entity.favorites?.allObjects as? [Recipe] ?? []
        for favorite in favorites {
            guard let recipe = RecipeModel(favorite) else { continue }
            self.favorites.append(recipe)
        }
        
        self.latest = []
        let latest = entity.favorites?.allObjects as? [Recipe] ?? []
        for late in latest {
            guard let recipe = RecipeModel(late) else { continue }
            self.latest.append(recipe)
        }
    }
    
    func encode(context: NSManagedObjectContext, existingEntity: Cookbook?) -> Cookbook {
        let result = existingEntity != nil ? existingEntity! : Cookbook(context: context)
        
        let existingFavorites = Set(result.favorites?.allObjects as? [Recipe] ?? [])
        for favorite in self.favorites {
            let existingRecipeEntity = existingFavorites.first(where: {$0.id == favorite.id})
            let favoriteEntity = favorite.encode(context: context, existingEntity: existingRecipeEntity)
            
            if existingRecipeEntity == nil {
                result.addToFavorites(favoriteEntity)
            }
        }
        
        let existingLatest = Set(result.latest?.allObjects as? [Recipe] ?? [])
        for late in self.latest {
            let existingRecipeEntity = existingFavorites.first(where: {$0.id == late.id})
            let lateEntity = late.encode(context: context, existingEntity: existingRecipeEntity)
            
            if existingRecipeEntity == nil {
                result.addToLatest(lateEntity)
            }
        }
        
        return result
    }
}
