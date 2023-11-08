//
//  RecipeCardVerticalSmallViewModel.swift
//  Gourmetus
//
//  Created by Thiago Defini on 07/11/23.
//

import Foundation

class RecipeCardVerticalSmallViewModel: ObservableObject {
    
    @Published var recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    
    
}
