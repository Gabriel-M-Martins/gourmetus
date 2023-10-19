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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
