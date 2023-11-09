//
//  TabBarView.swift
//  Gourmetus
//
//  Created by Thiago Defini on 01/11/23.
//

import SwiftUI

struct TabBarView: View {
    
    @Injected private var cookbookRepo: any Repository<Cookbook>
    
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
            if let aux = cookbookRepo.fetch().first {
                self.cookbook.id = aux.id
                self.cookbook.ownedRecipes = aux.ownedRecipes
                self.cookbook.favorites = aux.favorites
                self.cookbook.history = aux.history
                self.cookbook.community = aux.community
            }else{
                self.cookbook.ownedRecipes = Constants.mockedRecipes
//                self.cookbook.favorites = Constants.mockedRecipeArray
                self.cookbook.history = Constants.mockedRecipes
                self.cookbook.community = Constants.mockedRecipes
                cookbookRepo.save(cookbook)
            }
        })
    }
}

#Preview {
    TabBarView()
}
