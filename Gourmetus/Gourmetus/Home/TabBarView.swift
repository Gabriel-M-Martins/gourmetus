//
//  TabBarView.swift
//  Gourmetus
//
//  Created by Thiago Defini on 01/11/23.
//

import SwiftUI

struct TabBarView: View {
    
    @Injected private var repo: any Repository<Cookbook>
    
    @StateObject var cookbook: Cookbook = Cookbook()
    
    var body: some View {
        TabView{
            
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .environmentObject(cookbook)
            
            RecipesListsView(listType: .RecentlyAccessed)
                .tabItem {
                    Label("Cookbook", systemImage: "text.book.closed.fill")
                }
                .environmentObject(cookbook)
            
            HomeView()
                .tabItem {
                    Label("My Kitchen", systemImage: "stove.fill")
                }
                .environmentObject(cookbook)

        }
        .onAppear(perform: {
            if let aux = repo.fetch().first {
                self.cookbook.id = aux.id
                self.cookbook.ownedRecipes = aux.ownedRecipes
                self.cookbook.favorites = aux.favorites
                self.cookbook.history = aux.history
                self.cookbook.community = aux.community
            }else{
                self.cookbook.ownedRecipes = Constants.mockedRecipeArray
//                self.cookbook.favorites = Constants.mockedRecipeArray
                self.cookbook.history = Constants.mockedRecipeArray
                self.cookbook.community = Constants.mockedRecipeArray
                repo.save(cookbook)
            }
        })
    }
}

#Preview {
    TabBarView()
}
