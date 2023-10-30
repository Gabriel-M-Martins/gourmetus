//
//  GourmetusApp.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 19/10/23.
//

import SwiftUI

@main
struct GourmetusApp: App {
    let persistenceController = PersistenceController.shared

    @State var recipe: RecipeModel? = Constants.mockedRecipe
    var body: some Scene {
        WindowGroup {
           CreateEditRecipeView(recipe: $recipe)
        }
    }
}
