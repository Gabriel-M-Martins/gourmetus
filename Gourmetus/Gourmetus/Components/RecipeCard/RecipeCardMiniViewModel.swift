//
//  RecipeCardMiniViewModel.swift
//  Gourmetus
//
//  Created by Thiago Defini on 07/11/23.
//

import Foundation

class RecipeCardMiniViewModel: ObservableObject {
    
    @Published var recipe: RecipeModel
    
    init(recipe: RecipeModel) {
        self.recipe = recipe
    }
    
}
