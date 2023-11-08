//
//  RecipeDetailsViewModel.swift
//  Gourmetus
//
//  Created by Thiago Defini on 25/10/23.
//

import Foundation

class RecipeDetailsViewModel: ObservableObject{
    @Published var recipe: Recipe
    @Published var homeViewModel: HomeViewModel
    
    init(recipe: Recipe, homeViewModel: HomeViewModel) {
        self.recipe = recipe
        self.homeViewModel = homeViewModel
    }
    
}
