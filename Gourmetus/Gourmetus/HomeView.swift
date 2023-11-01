//
//  HomeView.swift
//  Gourmetus
//
//  Created by Thiago Defini on 25/10/23.
//

import SwiftUI

struct HomeView: View {
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack{
            ScrollView{
                Divider()
                titleRecentlyAccessed
                scrollViewRecentlyAccessed
                Divider()
                    .padding(.vertical, 8)
//                titleFavourites
                aux
                scrollViewFavourites
                Divider()
                    .padding(.vertical, 8)
                titleMyRecipes
                scrollViewMyRecipes
                Divider()
                    .padding(.vertical, 8)
                titleCommunity
                scrollViewCommunity
                
            }
            .navigationTitle("Menu")
            .toolbar{
                Button{
                    
                }label: {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.orange)
                }
            }
            .searchable(text: $searchText, placement: .automatic, prompt: "Search")
        }
    }
}

extension HomeView {
    
    private var titleRecentlyAccessed: some View {
        Button{
            
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
                ForEach(Constants.mockedRecipeArray) { recipe in
                    RecentlyAccessedRow(recipe: recipe)
                }
            }
            .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
    }
    
    private var titleFavourites: some View {
        Button{
            
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
    
    private var aux: some View {
        Button{
        Notification.setTimer(time: 5, title: "A", subtitle: "B")
        }label: {
            HStack{
                Text("Click here")
                    .font(.title2)
                    .foregroundStyle(.green)
                    .padding(.leading)
            }
        }
    }
    
    private var scrollViewFavourites: some View {
        ScrollView(.horizontal){
            HStack(spacing: 16){
                ForEach(Constants.mockedRecipeArray) { recipe in
                    FavouritesRow(recipe: recipe)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 2)
        }
        .frame(height: 136)
        .scrollIndicators(.hidden)
    }
    
    private var titleMyRecipes: some View {
        Button{
            
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
                ForEach(Constants.mockedRecipeArray) { recipe in
                    MyRecipesRow(recipe: recipe)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 2)
        }
        .scrollIndicators(.hidden)
    }
    
    private var titleCommunity: some View {
        Button{
            
        }label: {
            HStack{
                Text("Community")
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
    
    private var scrollViewCommunity: some View {
        VStack{
            ForEach(Constants.mockedRecipeArray) { recipe in
                CommunityRow(recipe: recipe)
                    .padding(.vertical, 8)
            }
            .padding(.horizontal)
        }
    }
    
}



#Preview {
    HomeView()
}
