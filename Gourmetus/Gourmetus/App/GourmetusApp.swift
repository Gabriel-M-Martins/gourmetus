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
    
//    @StateObject var cookBook = Cookbook
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
