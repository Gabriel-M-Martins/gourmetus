//
//  RecipesListsView.swift
//  Gourmetus
//
//  Created by Thiago Defini on 31/10/23.
//

import SwiftUI

struct RecipesListsView: View {
    var listType: ListType
    
    @EnvironmentObject var cookbook: Cookbook
    
    @State var searchedText: String = ""
    @State private var presentTagSheet: Bool = false
    @State private var selectedTags: Set<String> = []
    
    private func filterRecipes(_ recipes: [Recipe]) -> [Recipe] {
        var result: [Recipe] = recipes
        
        if !selectedTags.isEmpty {
            result = result.filter { recipe in
                Set(recipe.tags.map({ $0.name })).isSuperset(of: selectedTags)
            }
        }
        
        if !searchedText.isEmpty {
            result = result.filter { recipe in
                recipe.name.uppercased().contains(searchedText.uppercased())
            }
        }
        
        return result
    }
    
    var recipes: [Recipe] {
        var result: [Recipe] = []
        
        switch self.listType {
        case .History:
            result = cookbook.history
        case .Owned:
            result = cookbook.ownedRecipes
        case .Favorites:
            result = cookbook.favorites
        }
        
        return filterRecipes(result)
    }
    
    var body: some View {
        ScrollView {
            Divider()
            
            HStack {
                Text(listType.subtitle)
                    .modifier(Header())
                    .padding(.leading, default_spacing)
                Spacer()
            }
            .padding(.vertical ,default_spacing)
            
            Divider()
            
            if recipes.isEmpty {
                VStack{
                    Spacer()
                    Text("Nothing to see here yet.")
                        .modifier(Title())
                        .foregroundStyle(Color.color_text_container_highlight)
                    Spacer()
                }
                .padding(default_spacing)
            } else {
                ForEach(recipes) { recipe in
                    NavigationLink {
                        RecipeDetailsView(recipe: recipe)
                    } label: {
                        VStack {
                            if listType == .History {
                                HStack {
                                    Text(recipe.completed ? "Completed" : "Continue")
                                        .modifier(Span())
                                        .foregroundColor(recipe.completed ? Color.color_text_container_highlight : Color.color_text_container_muted )
                                    Spacer()
                                }
                                .padding(.horizontal, default_spacing)
                                .padding(.top, default_spacing)
                            }
                            
                            RecipeCardVerticalBig(recipe: recipe, isFavorite: .init(get: { cookbook.isFavoritedRecipe(recipe: recipe) }, set: {_ in return}), favoriteButtonClosure: { withAnimation {
                                _ = cookbook.toggleFavourite(recipe: recipe)
                            } })
                            .tint(Color(uiColor: UIColor.label))
                            .padding(.vertical, default_spacing)
                            
                            if listType == .History {
                                Divider()
                                    .padding(.horizontal, default_spacing)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(listType.title)
        .searchable(text: $searchedText, placement: .automatic, prompt: "Search")
        .sheet(isPresented: $presentTagSheet) {
            TagFilterSearchView(selectedTags: $selectedTags)
            .presentationDetents([.fraction(1 * 0.8), .large])
            .presentationDragIndicator(.visible)
        }
        .toolbar {
            if listType == .Owned {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        CreateEditRecipeView()
                    } label: {
                        Image.plus
                            .foregroundStyle(Color.color_button_container_primary)
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    presentTagSheet = true
                } label: {
                    Image.filter
                        .foregroundStyle(Color.color_button_container_primary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RecipesListsView(listType: .History)
    }
    .environmentObject(Constants.mockedCookbook)
        
}
