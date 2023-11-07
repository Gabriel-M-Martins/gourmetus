//
//  HomeViewModel.swift
//  Gourmetus
//
//  Created by Thiago Defini on 30/10/23.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    var model: CookBookModel
    
    @Published var recentlyAccessed: [RecipeModel]
    @Published var favourites: [RecipeModel]
    @Published var myRecipes: [RecipeModel]
    @Published var community: [RecipeModel]
    
    
    
    init() {
        if let cookModel = CoreDataCookBookRepository.fetch().first {
            self.model = cookModel
        } else {
            self.model = CookBookModel(id: UUID(), favorites: [], latest: [])
        }
        
        self.recentlyAccessed = model.latest
//        self.recentlyAccessed = Constants.mockedRecipeArray
        self.favourites = model.favorites
        self.myRecipes = Constants.mockedRecipeArray
        self.community = Constants.mockedRecipeArray
    }
    
    func isFavorited(recipe: RecipeModel) -> Bool{
        for favourite in favourites{
            if favourite.id == recipe.id{
                return true
            }
        }
        return false
    }
    
    func toggleFavourite(recipe: RecipeModel){
        if self.isFavorited(recipe: recipe){
            for index in 0..<self.favourites.count{
                self.favourites.remove(at: index)
            }
        } else {
            self.favourites.append(recipe)
        }
    }
    
}
