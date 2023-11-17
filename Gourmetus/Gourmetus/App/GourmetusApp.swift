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
            //       .environment(\.managedObjectContext, persistenceController.container.viewContext)
            TabBarView()
//            NavigationStack {
//                SearchView()
//            }
        }
        
    }
    
}
