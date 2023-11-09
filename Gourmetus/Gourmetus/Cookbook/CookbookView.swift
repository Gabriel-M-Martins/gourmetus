//
//  CookbookView.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 09/11/23.
//

import SwiftUI

struct CookbookView: View {
    private let scale: CGFloat = UIScreen.main.bounds.width/1.2
    
    @EnvironmentObject private var cookbook: Cookbook
    
    var body: some View {
        ScrollView {
            VStack {
                Divider()
                
                HStack {
                    Spacer()
                    
                    VStack {
                        CookbookCard(title: "Recently Accessed", subtitle: "\(cookbook.history.count) Recipes Inside", book: .history, destination: {
                            Text("Recentes")
                        })
                            .frame(width: scale)
                        Divider()
                        
                        CookbookCard(title: "My Recipes", subtitle: "\(cookbook.ownedRecipes.count) Recipes Inside", book: .ownedRecipes, destination: {
                            Text("Meus")
                        })
                            .frame(width: scale)
                        Divider()
                        
                        CookbookCard(title: "Favorite Recipes", subtitle: "\(cookbook.favorites.count) Recipes Inside", book: .favorites, destination: {
                            Text("Favoritas")
                        })
                            .frame(width: scale)
                        Divider()
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationTitle("Cookbook")
        .searchable(text: .constant(""))
    }
}

#Preview {
    NavigationStack {
        CookbookView()
    }
    .environmentObject(Cookbook(ownedRecipes: Constants.mockedRecipes, favorites: Constants.mockedRecipes, history: Constants.mockedRecipes))
}
