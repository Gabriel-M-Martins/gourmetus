//
//  RecipeCardVerticalBigViewModel.swift
//  Gourmetus
//
//  Created by Thiago Defini on 07/11/23.
//

import Foundation

class RecipeCardVerticalBigViewModel: ObservableObject {
    @Injected private var repo: any Repository<Cookbook>
    @Published var cookBook: Cookbook? {
        didSet {
//            print("Alterou o cookbook")
        }
    }
    @Published var favourites: Set<Recipe> = [] {
        didSet {
            print("Alterou o favourites")
        }
    }
    @Published var recipe: Recipe
    
    var isFavorite: Bool {
        for favourite in favourites{
            if favourite.id == recipe.id{
                return true
            }
        }
        return false
    }
    
    init(recipe: Recipe) {
        self.recipe = recipe
        if let cookModel = repo.fetch().first{
            self.cookBook = cookModel
            self.favourites = Set(cookModel.favorites)
        }
    }
    
    func toggleFavourite(recipe: Recipe){
        if self.isFavorite{
            self.favourites.remove(recipe)
        } else {
            self.favourites.insert(recipe)
        }
//        if cookBook != nil{
        if var cookBook = cookBook {
            cookBook.favorites = Array(self.favourites)
            repo.save(cookBook)
        }
        
    }
    
}
