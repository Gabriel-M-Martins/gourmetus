//
//  RecipeCardVerticalBigViewModel.swift
//  Gourmetus
//
//  Created by Thiago Defini on 07/11/23.
//

import Foundation

class RecipeCardVerticalBigViewModel {
    @Published var cookBook: CookBookModel?
    @Published var favourites: Set<RecipeModel> = []
    @Published var recipe: RecipeModel
    
    var isFavorite: Bool {
        for favourite in favourites{
            if favourite.id == recipe.id{
                return true
            }
        }
        return false
    }
    
    init(recipe: RecipeModel) {
        self.recipe = recipe
        if let cookModel = CoreDataCookBookRepository.fetch().first{
            self.cookBook = cookModel
            self.favourites = Set(cookModel.favorites)
        }
    }
    
    func toggleFavourite(recipe: RecipeModel){
        if self.isFavorite{
            self.favourites.remove(recipe)
        } else {
            self.favourites.insert(recipe)
        }
        if cookBook != nil{
            CoreDataCookBookRepository.save(cookBook!)
        }
        
    }
    
}
