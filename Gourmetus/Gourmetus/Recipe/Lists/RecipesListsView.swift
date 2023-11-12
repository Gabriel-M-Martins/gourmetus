//
//  RecipesListsView.swift
//  Gourmetus
//
//  Created by Thiago Defini on 31/10/23.
//

import SwiftUI

struct RecipesListsView: View {
    
    @StateObject var vm : RecipesListsViewModel
    
    @EnvironmentObject var cookbook: Cookbook
    
    @State private var searchText = ""
    
    init(listType: ListType) {
        self._vm = StateObject(wrappedValue: RecipesListsViewModel(listType: listType))
    }
    
    var body: some View {
        ScrollView{
            Divider()
            HStack{
                Text(vm.listType.description2)
                    .modifier(Header())
                    .padding(.leading, default_spacing)
                Spacer()
            }
            .padding(.vertical ,default_spacing)
            
            switch vm.listType{
            case .History:
                if cookbook.history.isEmpty{
                emptyState
                }else{
                    historyList
                        .padding(.horizontal, default_spacing)
                }
            case .Favorites:
                if cookbook.favorites.isEmpty{
                emptyState
                }else{
                    favoritesList
                        .padding(.horizontal, default_spacing)
                }
            case .Owned:
                if cookbook.ownedRecipes.isEmpty{
                emptyState
                }else{
                    ownedList
                        .padding(.horizontal, default_spacing)
                }
            }
        }
        .navigationTitle(vm.listType.description)
        .searchable(text: $searchText, placement: .automatic, prompt: "Search")
    }
}

extension RecipesListsView {
    
    private var historyList: some View {
        ForEach(cookbook.history) { recipe in
            VStack(spacing: default_spacing){
                Divider()
                HStack{
                    Text("Completed")
                        .modifier(Span())
                        .foregroundColor(Color.color_text_container_highlight)
                    Spacer()
                }
                NavigationLink{
                    RecipeDetailsView(recipe: recipe)
                }label: {
                    RecipeCardVerticalBig(recipe: recipe)
                        .tint(Color(uiColor: UIColor.label))
                }
                .padding(.bottom, half_spacing)
            }
        }
    }
    
    private var favoritesList: some View {
        ForEach(cookbook.favorites) { recipe in
            VStack{
                NavigationLink{
                    RecipeDetailsView(recipe: recipe)
                }label: {
                    RecipeCardVerticalBig(recipe: recipe)
                        .tint(Color(uiColor: UIColor.label))
                        .padding(.bottom, default_spacing)
                }
            }
        }
    }
    
    private var ownedList: some View {
        ForEach(cookbook.ownedRecipes) { recipe in
            VStack{
                NavigationLink{
                    RecipeDetailsView(recipe: recipe)
                }label: {
                    RecipeCardVerticalBig(recipe: recipe)
                        .tint(Color(uiColor: UIColor.label))
                        .padding(.bottom, default_spacing)
                }
            }
        }
    }
    
    private var emptyState: some View {
        VStack{
            Spacer()
            Text("Nothing to see here yet.")
                .modifier(Title())
                .foregroundStyle(Color.color_text_container_highlight)
            Spacer()
        }
        .frame(height: 515)
//        .padding(.horizontal, default_spacing)
//        .background(.blue)
    }
    
}


#Preview {
    RecipesListsView(listType: .Favorites)
        .environmentObject(Constants.mockedCookbook1)
}
