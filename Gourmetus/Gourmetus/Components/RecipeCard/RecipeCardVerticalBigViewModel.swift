//
//  RecipeCardVerticalBigViewModel.swift
//  Gourmetus
//
//  Created by Thiago Defini on 07/11/23.
//

import Foundation

class RecipeCardVerticalBigViewModel: ObservableObject {
    @Published var cookBook: CookBookModel? {
        didSet {
//            print("Alterou o cookbook")
        }
    }
    @Published var favourites: Set<RecipeModel> = [] {
        didSet {
            print("Alterou o favourites")
        }
    }
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
//        if cookBook != nil{
        if var cookBook = cookBook {
            cookBook.favorites = Array(self.favourites)
            CoreDataCookBookRepository.save(cookBook)
        }
        
    }
    
}
