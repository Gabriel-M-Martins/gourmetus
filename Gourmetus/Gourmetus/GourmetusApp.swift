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

    @State var recipe: RecipeModel? = Constants.mockedRecipe
    
//    @StateObject var cookBook = CookBookModel
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
//            RecipeDetailsView(recipe: Constants.mockedRecipe)
            HomeView()
//            RecipesListsView(listType: .RecentlyAccessed, homeViewModel: HomeViewModel())
//            RecentlyAccessedRow(recipe: Constants.mockedRecipe)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
