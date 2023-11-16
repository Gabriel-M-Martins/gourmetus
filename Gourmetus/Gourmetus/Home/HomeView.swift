//
//  HomeView.swift
//  Gourmetus
//
//  Created by Thiago Defini on 25/10/23.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var vm: HomeViewModel = HomeViewModel()
    
    @EnvironmentObject var cookbook: Cookbook
    
    @State private var isShowing: Bool = false
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(spacing: 0){
                    //                Button(action: {
                    //                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    //                        if success {
                    //                            print("All set!")
                    //                        } else if let error = error {
                    //                            print(error.localizedDescription)
                    //                        }
                    //                    }
                    //                }, label: {
                    //                    Text("Button")
                    //                })
                    //                    Divider()
                    
                    //History
                    NavigationLink{
//                        self.isShowing = true
                        RecipesListsView(listType: .Owned)
                    } label: {
                        SearchBarView()
                    }
                    .fullScreenCover(isPresented: $isShowing) {
                        RecipesListsView(listType: .Owned)
                    }
                    VStack(spacing: 0){
                        if !cookbook.history.isEmpty {
                            titleRecentlyAccessed
                            scrollViewRecentlyAccessed
                        }
                    }
                    .padding(.bottom, default_spacing)
                    
                    Divider()
                    
                    //Favorites
                    VStack(spacing: 0){
                        
                        if !cookbook.favorites.isEmpty {
                            titleFavourites
                            scrollViewFavourites
                        }
                    }
                    .padding(.bottom, default_spacing)
                    
                    Divider()
                    
                    //Owned
                    VStack(spacing: 0){
                        titleMyRecipes
                        if cookbook.ownedRecipes.isEmpty {
                            emptyState
                            createRecipeButton
                        } else {
                            scrollViewMyRecipes
                        }
                    }
                    .padding(.bottom, default_spacing)
                    
                    Divider()
                    
                    //Community
                    VStack(spacing: 0){
                        
                        if !cookbook.community.isEmpty{
                            titleCommunity
                            scrollViewCommunity
                        }
                    }
                    
                }
                .navigationTitle("Menu")
                //                .searchable(text: $searchText, placement: .automatic, prompt: "Search")
            }
        }
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
            HStack(spacing: default_spacing){
                ForEach(cookbook.history) { recipe in
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
    
    private var titleFavourites: some View {
        NavigationLink{
            RecipesListsView(listType: .Favorites)
        }label: {
            HStack(alignment: .bottom, spacing: default_spacing){
                Text("Favourites")
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
    
    private var scrollViewFavourites: some View {
        ScrollView(.horizontal){
            HStack(spacing: default_spacing){
                ForEach(cookbook.favorites) { recipe in
                    NavigationLink{
                        RecipeDetailsView(recipe: recipe)
                    }label: {
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
        }label: {
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
                ForEach(cookbook.ownedRecipes) { recipe in
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
            ForEach(cookbook.community) { recipe in
                NavigationLink{
                    RecipeDetailsView(recipe: recipe)
                }label: {
                    RecipeCardVerticalBig(recipe: recipe)
                        .tint(Color(uiColor: UIColor.label))
                }
            }
            .padding(.horizontal, default_spacing)
        }
    }
    
    private var emptyState: some View {
        Text("It seems you don't have any recipe in your cookbook yet. Start adding someor browse the community!")
            .modifier(Paragraph())
            .padding(.horizontal,default_spacing)
            .padding(.bottom,default_spacing)
        
    }
    
    private var createRecipeButton: some View {
        NavigationLink{
            let recipe: Binding<Recipe?> = .constant(nil)
            CreateEditRecipeView(recipe: recipe)
        } label: {
            Text("Add recipe")
                .frame(width: UIScreen.main.bounds.width * 0.55, height: UIScreen.main.bounds.width * 0.075)
                .foregroundStyle(Color.color_general_fixed_light)
                .modifier(Header())
            
        }
        .tint(.color_button_container_primary)
        .buttonStyle(.borderedProminent)
        
    }
}

#Preview {
    HomeView()
        .environmentObject(Constants.mockedCookbook)
}
