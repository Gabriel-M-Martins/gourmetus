//
//  RecipesListsView.swift
//  Gourmetus
//
//  Created by Thiago Defini on 31/10/23.
//

import SwiftUI

struct RecipesListsView: View {
    
    @StateObject var vm : RecipesListsViewModel
    
    @State private var searchText = ""
    
    init(listType: ListType, homeViewModel: HomeViewModel) {
        self._vm = StateObject(wrappedValue: RecipesListsViewModel(listType: listType, homeviewModel: homeViewModel))

        
    }
    
    var body: some View {
            ScrollView{
                Divider()
                HStack{
                    Text(vm.listType.description2)
                        .font(.title)
                        .padding(.leading,16)
                    Spacer()
                }
                
                ForEach(vm.homeViewModel.community) { recipe in
                    VStack{
                        if vm.listType == .RecentlyAccessed{
                            Divider()
                            HStack{
                                Text("Completed")
                                    .foregroundColor(.green)
                                    .padding(.leading, 16)
                                Spacer()
                            }
                        }
                        NavigationLink{
                            RecipeDetailsView(recipe: recipe, homeViewModel: vm.homeViewModel)
                        }label: {
                            RecipeCardVerticalBig(recipe: recipe)
                                .padding(.vertical, 8)
                                .tint(Color(uiColor: UIColor.label))
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle(vm.listType.description)
            .searchable(text: $searchText, placement: .automatic, prompt: "Search")
            
    }
}

#Preview {
    RecipesListsView(listType: .RecentlyAccessed, homeViewModel: HomeViewModel())
}