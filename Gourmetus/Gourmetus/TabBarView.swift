//
//  TabBarView.swift
//  Gourmetus
//
//  Created by Thiago Defini on 01/11/23.
//

import SwiftUI

struct TabBarView: View {
    
    var body: some View {
        TabView{
            
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            RecipesListsView(listType: .RecentlyAccessed, homeViewModel: HomeViewModel())
                .tabItem {
                    Label("Cookbook", systemImage: "text.book.closed.fill")
                }
            
            HomeView()
                .tabItem {
                    Label("My Kitchen", systemImage: "stove.fill")
                }

        }
    }
}

#Preview {
    TabBarView()
}
