//
//  GourmetusApp.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 19/10/23.
//

import SwiftUI

@main
struct GourmetusApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared

    @State var recipe: Recipe? = Constants.mockedRecipe
    
    var body: some Scene {
        WindowGroup {
               TabBarView()
            //       .environment(\.managedObjectContext, persistenceController.container.viewContext)
//            CreateEditStepView(editingStep: .constant(Constants.mockedSteps[0]),ingredients: [Ingredient(id: UUID(), name: "Farinha", quantity: "0.5", unit: .Kg),
//                               Ingredient(id: UUID(), name: "Ovo", quantity: "3", unit: .L)], recipeViewModel: CreateEditRecipeViewModel(), showSheet: .constant(false))
<<<<<<< Updated upstream
=======
                   .environment(\.managedObjectContext, persistenceController.container.viewContext)
            //CreateEditStepView(editingStep: .constant(Constants.mockedSteps[0]),ingredients: [Ingredient(id: UUID(), name: "Farinha", quantity: "0.5", unit: .Kg),
            //                   Ingredient(id: UUID(), name: "Ovo", quantity: "3", unit: .L)], recipeViewModel: CreateEditRecipeViewModel(), showSheet: .constant(false))
>>>>>>> Stashed changes
        }
        
    }
    
}
