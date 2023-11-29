//
//  TabBarView.swift
//  Gourmetus
//
//  Created by Thiago Defini on 01/11/23.
//

import SwiftUI

struct TabBarView: View {
    
    @StateObject private var cookbook: Cookbook = Cookbook()
    
    var body: some View {
        TabView{
            
            NavigationStack {
                HomeView()
            }
            .environmentObject(cookbook)
            .tabItem {
                Label("Home", systemImage: "fork.knife")
            }
            
            NavigationStack {
                CookbookView()
            }
            .environmentObject(cookbook)
            .tabItem {
                Label("Cookbook", systemImage: "text.book.closed.fill")
            }
            
//            NavigationStack {
//                SearchView()
//            }
//            .environmentObject(cookbook)
//            .tabItem {
//                Label("My Kitchen", systemImage: "stove.fill")
//            }
            
        }
        .tint(Color.color_button_container_primary)
        .onAppear {
            cookbook.fetch()
        }
    }
}

#Preview {
    TabBarView()
}
