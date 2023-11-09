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
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack{
            ScrollView{
                Button(action: {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success {
                            print("All set!")
                        } else if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                }, label: {
                    /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                })
                Divider()
                titleRecentlyAccessed
                if cookbook.history.isEmpty {
                    
                } else {
                    scrollViewRecentlyAccessed
                }
                Divider()
                    .padding(.vertical, 8)
                titleFavourites
                if cookbook.favorites.isEmpty {
                    
                } else {
                    scrollViewFavourites
                }
                Divider()
                    .padding(.vertical, 8)
                titleMyRecipes
                if cookbook.ownedRecipes.isEmpty {
                    
                } else {
                    scrollViewMyRecipes
                }
                Divider()
                    .padding(.vertical, 8)
                titleCommunity
                if cookbook.community.isEmpty{
                    
                }else{
                    scrollViewCommunity
                }
                
            }
            .navigationTitle("Menu")
            .searchable(text: $searchText, placement: .automatic, prompt: "Search")
        }
    }
}

extension HomeView {
    
    private var titleRecentlyAccessed: some View {
        NavigationLink{
            RecipesListsView(listType: .RecentlyAccessed)
        }label: {
            HStack{
                Text("Recently accessed")
                    .font(.title2)
                    .foregroundStyle(.green)
                    .padding(.leading)
                Spacer()
                Text("View all >")
                    .font(.subheadline)
                    .foregroundStyle(.orange)
                    .padding(.trailing)
            }
        }
        
    }
    
    private var scrollViewRecentlyAccessed: some View {
        ScrollView(.horizontal){
            HStack(spacing: 16){
                ForEach(cookbook.history) { recipe in
                    NavigationLink{
                        RecipeDetailsView(recipe: recipe)
                        
                    }label: {
                        RecipeCardMini(recipe: recipe)
                            .tint(Color(uiColor: UIColor.label))
                    }
                }
            }
            .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
    }
    
    private var titleFavourites: some View {
        NavigationLink{
            RecipesListsView(listType: .FavouritesRecipes)
        }label: {
            HStack{
                Text("Favourites")
                    .font(.title2)
                    .foregroundStyle(.green)
                    .padding(.leading)
                Spacer()
                Text("View all >")
                    .font(.subheadline)
                    .foregroundStyle(.orange)
                    .padding(.trailing)
            }
        }
    }
    
    private var scrollViewFavourites: some View {
        ScrollView(.horizontal){
            HStack(spacing: 16){
                if cookbook.favorites.isEmpty {
                    Text("It seems you don't have any recipe in your cookbook yet. Start Adding some or browse the community!")
                } else {
                    ForEach(cookbook.favorites, id: \.id) { recipe in
                        NavigationLink{
                            RecipeDetailsView(recipe: recipe)
                        }label: {
                            RecipeCardHorizontal(recipe: recipe)
                                .tint(Color(uiColor: UIColor.label))
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 2)
        }
        .frame(height: 136)
        .scrollIndicators(.hidden)
    }
    
    private var titleMyRecipes: some View {
        NavigationLink{
            RecipesListsView(listType: .MyRecipes)
        }label: {
            HStack{
                Text("My Recipes")
                    .font(.title2)
                    .foregroundStyle(.green)
                    .padding(.leading)
                Spacer()
                Text("View all >")
                    .font(.subheadline)
                    .foregroundStyle(.orange)
                    .padding(.trailing)
            }
        }
    }
    
    private var scrollViewMyRecipes: some View {
        ScrollView(.horizontal){
            HStack(){
                ForEach(cookbook.ownedRecipes) { recipe in
                    NavigationLink{
                        RecipeDetailsView(recipe: recipe)
                    }label: {
                        RecipeCardVerticalSmall(recipe: recipe)
                            .tint(Color(uiColor: UIColor.label))
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 2)
        }
        .scrollIndicators(.hidden)
    }
    
    private var titleCommunity: some View {
        HStack{
            Text("Community")
                .font(.title2)
                .foregroundStyle(.green)
                .padding(.leading)
            Spacer()
        }
        
    }
    
    private var scrollViewCommunity: some View {
        VStack{
            ForEach(cookbook.community) { recipe in
                NavigationLink{
                    RecipeDetailsView(recipe: recipe)
                }label: {
                    RecipeCardVerticalBig(recipe: recipe)
                        .padding(.vertical, 8)
                        .tint(Color(uiColor: UIColor.label))
                }
            }
            .padding(.horizontal)
        }
    }
    
}



#Preview {
    HomeView()
}
