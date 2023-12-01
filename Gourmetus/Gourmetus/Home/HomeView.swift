//
//  HomeView.swift
//  Gourmetus
//
//  Created by Thiago Defini on 25/10/23.
//

import SwiftUI

struct HomeView: View {
    
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
    
    var body: some View {
        ScrollView {
            if cookbook.history.isEmpty && cookbook.community.isEmpty{
                VStack{
//                    Spacer()
                    Text("Nothing to see here yet.")
                        .modifier(Title())
                        .foregroundStyle(Color.color_text_container_highlight)
                        
//                    Spacer()
                }
                .padding(default_spacing)
                .padding(.top, UIScreen.main.bounds.height*0.2)
            }else{
                VStack(spacing: 0) {
                    Divider()
                    //History
                    VStack(spacing: 0){
                        if !cookbook.history.isEmpty {
                            titleRecentlyAccessed
                            scrollViewRecentlyAccessed
                        }
                    }
                    .padding(.bottom, default_spacing)
                    
                    Divider()
                    
                    //Community
                    if !cookbook.community.isEmpty{
                        titleCommunity
                        scrollViewCommunity
                    }
                    
                    
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .searchable(text: $searchedText)
        .navigationTitle("Menu")
        
        .sheet(isPresented: $presentTagSheet) {
            TagFilterSearchView(selectedTags: $selectedTags)
                .presentationDetents([.fraction(1 * 0.8), .large])
                .presentationDragIndicator(.visible)
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    CreateEditRecipeView()
                } label: {
                    Image.plus
                        .foregroundStyle(Color.color_button_container_primary)
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
        })
    }
}

extension HomeView {
    
    private var titleRecentlyAccessed: some View {
        NavigationLink{
            RecipesListsView(listType: .History)
        }label: {
            HStack(alignment: .bottom, spacing: default_spacing){
                Text("Recently accessed")
                    .modifier(Header())
                    .foregroundStyle(Color.color_text_container_highlight)
                Spacer()
                Text("View all \(Image.chevronRight)")
                    .modifier(Span())
                    .foregroundStyle(Color.color_button_container_primary)
            }
            
        }
        .padding(.horizontal, default_spacing)
        .padding(.vertical, default_spacing)
        
    }
    
    private var scrollViewRecentlyAccessed: some View {
        ScrollView(.horizontal){
            HStack(spacing: default_spacing) {
                ForEach(filterRecipes(cookbook.history)) { recipe in
                    NavigationLink{
                        RecipeDetailsView(recipe: recipe)
                    }label: {
                        RecipeCardMini(recipe: recipe)
                            .tint(Color(uiColor: UIColor.label))
                    }
                }
            }
            
            .padding(.horizontal, default_spacing)
        }
        .scrollIndicators(.hidden)
    }
    
    private var titleFavorites: some View {
        NavigationLink{
            RecipesListsView(listType: .Favorites)
        }label: {
            HStack(alignment: .bottom, spacing: default_spacing){
                Text("Favorites")
                    .modifier(Header())
                    .foregroundStyle(Color.color_text_container_highlight)
                Spacer()
                Text("View all \(Image.chevronRight)")
                    .modifier(Span())
                    .foregroundStyle(Color.color_button_container_primary)
            }
        }
        .padding(.horizontal, default_spacing)
        .padding(.vertical, default_spacing)
    }
    
    private var scrollViewFavorites: some View {
        ScrollView(.horizontal){
            HStack(spacing: default_spacing) {
                ForEach(filterRecipes(cookbook.favorites)) { recipe in
                    NavigationLink{
                        RecipeDetailsView(recipe: recipe)
                    } label: {
                        RecipeCardHorizontal(recipe: recipe)
                            .tint(Color(uiColor: UIColor.label))
                    }
                }
                
            }
            .padding(.horizontal, default_spacing)
        }
        .scrollIndicators(.hidden)
    }
    
    private var titleMyRecipes: some View {
        NavigationLink{
            RecipesListsView(listType: .Owned)
        } label: {
            HStack(alignment: .bottom, spacing: default_spacing){
                Text("My Recipes")
                    .modifier(Header())
                    .foregroundStyle(Color.color_text_container_highlight)
                Spacer()
                Text("View all \(Image.chevronRight)")
                    .modifier(Span())
                    .foregroundStyle(Color.color_button_container_primary)
            }
        }
        .padding(.horizontal, default_spacing)
        .padding(.vertical, default_spacing)
    }
    
    private var scrollViewMyRecipes: some View {
        ScrollView(.horizontal){
            HStack(spacing: default_spacing){
                ForEach(filterRecipes(cookbook.ownedRecipes)) { recipe in
                    NavigationLink{
                        RecipeDetailsView(recipe: recipe)
                    }label: {
                        RecipeCardVerticalSmall(recipe: recipe)
                            .tint(Color(uiColor: UIColor.label))
                    }
                }
            }
            .padding(.horizontal, default_spacing)
            
        }
        .scrollIndicators(.hidden)
    }
    
    private var titleCommunity: some View {
        HStack(alignment: .bottom, spacing: default_spacing){
            Text("Community")
                .modifier(Header())
                .foregroundStyle(Color.color_text_container_highlight)
            Spacer()
        }
        .padding(.horizontal, default_spacing)
        .padding(.vertical, default_spacing)
    }
    
    private var scrollViewCommunity: some View {
        VStack(spacing: default_spacing){
            ForEach(filterRecipes(cookbook.community)) { recipe in
                NavigationLink {
                    RecipeDetailsView(recipe: recipe)
                } label: {
                    RecipeCardVerticalBig(recipe: recipe, isFavorite: .init(get: { cookbook.isFavoritedRecipe(recipe: recipe) }, set: {_ in return}), favoriteButtonClosure: { withAnimation {
                        _ = cookbook.toggleFavorite(recipe: recipe)
                    } })
                    .tint(Color(uiColor: UIColor.label))
                    .padding(.bottom, default_spacing)
                }
            }
            .padding(.horizontal, default_spacing)
        }
    }
    
    private var emptyState: some View {
        VStack {
            if !searchedText.isEmpty || !selectedTags.isEmpty {
                Text("It seems there aren't any recipes that match your search in your cookbook yet.")
                    .modifier(Paragraph())
                    .padding(.horizontal, default_spacing)
                    .padding(.bottom, default_spacing)
            } else {
                Text("It seems you don't have any recipe in your cookbook yet. Start adding some or browse the community!")
                    .modifier(Paragraph())
                    .padding(.horizontal, default_spacing)
                    .padding(.bottom, default_spacing)
            }
        }
    }

}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environmentObject(Constants.mockedCookbook)
}
