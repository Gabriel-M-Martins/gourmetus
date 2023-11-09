//
//  CookbookView.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 09/11/23.
//

import SwiftUI

struct CookbookView: View {
    var body: some View {
        ScrollView {
            VStack {
                Divider()
                
                HStack {
                    Spacer()
                    
                    VStack {
                        CookbookCard(title: "Recently Accessed", subtitle: "23 Recipes Inside", book: .history, destination: {
                            Text("Recentes")
                        })
                            .frame(width: UIScreen.main.bounds.width/1.2)
                        Divider()
                        
                        CookbookCard(title: "My Recipes", subtitle: "18 Recipes Inside", book: .ownedRecipes, destination: {
                            Text("Meus")
                        })
                            .frame(width: UIScreen.main.bounds.width/1.2)
                        Divider()
                        
                        CookbookCard(title: "Favorite Recipes", subtitle: "6 Recipes Inside", book: .favorites, destination: {
                            Text("Favoritas")
                        })
                            .frame(width: UIScreen.main.bounds.width/1.2)
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
}
