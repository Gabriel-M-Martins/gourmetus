//
//  RecipesListsView.swift
//  Gourmetus
//
//  Created by Thiago Defini on 31/10/23.
//

import SwiftUI

struct RecipesListsView: View {
    
    @ObservedObject var homeViewModel: HomeViewModel
    
    @StateObject var recipesListsViewModel: RecipesListsViewModel
    
    @State private var searchText = ""
    
    init(listType: ListType, homeViewModel: HomeViewModel) {
        self._recipesListsViewModel = StateObject(wrappedValue: RecipesListsViewModel(listType: listType))
        self.homeViewModel = homeViewModel
        
    }
    
    var body: some View {
            ScrollView{
                Divider()
                HStack{
                    Text(recipesListsViewModel.listType.description2)
                        .font(.title)
                        .padding(.leading,16)
                    Spacer()
                }
                
                ForEach(homeViewModel.community) { recipe in
                    if recipesListsViewModel.listType == .RecentlyAccessed{
                        Divider()
                        HStack{
                            Text("Completed")
                                .foregroundColor(.green)
                                .padding(.leading, 16)
                            Spacer()
                        }
                    }
                    NavigationLink{
                        RecipeDetailsView(recipe: recipe, homeViewModel: homeViewModel)
                    }label: {
                        CommunityRow(recipe: recipe, homeViewModel: homeViewModel)
                            .padding(.vertical, 8)
                            .tint(Color(uiColor: UIColor.label))
                    }
                    
                }
                .padding(.horizontal)
            }
            .navigationTitle(recipesListsViewModel.listType.description)
            .searchable(text: $searchText, placement: .automatic, prompt: "Search")
            
    }
}

#Preview {
    RecipesListsView(listType: .RecentlyAccessed, homeViewModel: HomeViewModel())
}
