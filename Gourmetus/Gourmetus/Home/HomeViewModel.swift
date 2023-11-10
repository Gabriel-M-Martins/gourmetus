//
//  HomeViewModel.swift
//  Gourmetus
//
//  Created by Thiago Defini on 30/10/23.
//

import Foundation

class HomeViewModel: ObservableObject {
    
//    var cookbook: Cookbook? = nil
//    
//    @Published var recentlyAccessed: [Recipe] = []
//    @Published var favourites: [Recipe] = []
//    @Published var myRecipes: [Recipe] = []
//    @Published var community: [Recipe] = []
    
//    @Injected private var repo: any Repository<Cookbook>
    
    
//    init() {
//        if let cookbook = repo.fetch().first {
//            self.cookbook = cookbook
//        }
//
//        self.recentlyAccessed = cookbook?.history ?? self.recentlyAccessed
//        self.favourites = cookbook?.favorites ?? self.favourites
//        
//        self.myRecipes = Constants.mockedRecipeArray
//        self.community = Constants.mockedRecipeArray
//    }
    
//    func isFavorited(recipe: Recipe) -> Bool{
//        for favourite in favourites{
//            if favourite.id == recipe.id{
//                return true
//            }
//        }
//        return false
//    }
    
//    func toggleFavourite(recipe: Recipe){
//        if self.isFavorited(recipe: recipe){
//            for index in 0..<self.favourites.count{
//                self.favourites.remove(at: index)
//            }
//        } else {
//            self.favourites.append(recipe)
//        }
//    }
    
}
