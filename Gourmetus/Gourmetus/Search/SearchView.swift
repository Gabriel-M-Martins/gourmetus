//
//  SearchView.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 13/11/23.
//

import SwiftUI

protocol SearchDelegate {
    var cookbook: Cookbook { get }
}

final class SearchViewModel: ObservableObject {
    @Injected private var tagRepository: any Repository<Tag>
    
    var delegate: SearchDelegate?
    
    @Published var tags: [Tag] = []
    @Published var selectedTags: Set<String> = []
    @Published var searchedText: String = ""
    
    var favorites: [Recipe] {
        self.filterBySearch(recipes: delegate?.cookbook.favorites ?? [])
    }
    
    var ownedRecipes: [Recipe] {
        self.filterBySearch(recipes: delegate?.cookbook.ownedRecipes ?? [])
    }
    
    var community: [Recipe] {
        self.filterBySearch(recipes: delegate?.cookbook.community ?? [])
    }
    
    func fetchData() {
        /* TODO: Investigar os ids das tags que as receitas usam.
         * Por algum motivo as tags que as receitas tem são diferentes das tags que o banco consegue buscar. Não entendi o motivo... :/
         */
        tags = tagRepository.fetch()
    }
    
    func toggleTag(_ tag: Tag) {
        if selectedTags.contains(tag.name) {
            selectedTags.remove(tag.name)
        } else {
            selectedTags.insert(tag.name)
        }
    }
    
    func filterBySearch(recipes: [Recipe]) -> [Recipe] {
        let filteredByTags = recipes.filter { recipe in
            if selectedTags.isEmpty {
                return true
            }
            
            return Set(recipe.tags.map({ $0.name })).isSuperset(of: selectedTags)
        }
        
        let filteredByText = filteredByTags.filter { recipe in
            if searchedText.isEmpty {
                return true
            }
            
            return recipe.name.uppercased().contains(searchedText.uppercased())
        }
        
        return filteredByText
    }
}

struct SearchView: View, SearchDelegate {
    @StateObject private var vm: SearchViewModel = SearchViewModel()
    
    @EnvironmentObject var cookbook: Cookbook
    
    @State private var presentTagSheet: Bool = false
    
    private var searchedText: Binding<String> {
        Binding {
            self.vm.searchedText
        } set: {
            self.vm.searchedText = $0
        }
        
    }
    
    var searchedFromOrigin: Bool = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: default_spacing) {
                if searchedFromOrigin {
                    if !self.vm.favorites.isEmpty {
                        VStack {
                            HStack {
                                Text("Favourites")
                                    .foregroundStyle(Color.color_text_container_highlight)
                                    .modifier(Header())
                                Spacer()
                            }
                            .padding(.horizontal, default_spacing)
                            
                            ScrollView(.horizontal) {
                                LazyHStack {
                                    ForEach(cookbook.favorites) { recipe in
                                        NavigationLink {
                                            RecipeDetailsView(recipe: recipe)
                                        } label: {
                                            RecipeCardHorizontal(recipe: recipe)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.leading, default_spacing)
                            }
                            .scrollIndicators(.hidden)
                            
                            Divider()
                                .padding(default_spacing)
                        }
                    }
                    
                    if !self.vm.ownedRecipes.isEmpty {
                        VStack {
                            HStack {
                                Text("My Recipes")
                                    .foregroundStyle(Color.color_text_container_highlight)
                                    .modifier(Header())
                                Spacer()
                            }
                            .padding(.horizontal, default_spacing)
                            
                            ScrollView(.horizontal) {
                                LazyHStack {
                                    ForEach(cookbook.ownedRecipes) { recipe in
                                        NavigationLink {
                                            RecipeDetailsView(recipe: recipe)
                                        } label: {
                                            RecipeCardVerticalSmall(recipe: recipe)
                                        }
                                    }
                                }
                                .padding(.leading, default_spacing)
                            }
                            .scrollIndicators(.hidden)
                            
                            Divider()
                                .padding(default_spacing)
                        }
                    }
                    
                    
                    if !self.vm.community.isEmpty {
                        VStack {
                            HStack {
                                Text("Community")
                                    .foregroundStyle(Color.color_text_container_highlight)
                                    .modifier(Header())
                                Spacer()
                            }
                            .padding(.horizontal, default_spacing)
                            
                            ForEach(cookbook.community) { recipe in
                                NavigationLink {
                                    RecipeDetailsView(recipe: recipe)
                                } label: {
                                    RecipeCardVerticalBig(recipe: recipe, isFavorite: .init(get: { cookbook.isFavoritedRecipe(recipe: recipe) }, set: {_ in return}), favoriteButtonClosure: { withAnimation {
                                        _ = cookbook.toggleFavourite(recipe: recipe)
                                    } })
                                    .tint(Color(uiColor: UIColor.label))
                                    .padding(.bottom, default_spacing)
                                }
                            }
                        }
                    }
                    
                } else {
                    
                }
            }
        }
        .sheet(isPresented: $presentTagSheet, content: {
            VStack {
                HStack {
                    Text("Filters")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button {
                        presentTagSheet = false
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(Color.color_text_container_primary)
                    }
                }
                .padding(default_spacing)
                
                ChipsStack {
                    ForEach(vm.tags) { tag in
                        Button {
                            withAnimation {
                                vm.toggleTag(tag)
                            }
                        } label: {
                            TagView(text: tag.name,
                                    selected: .init(
                                        get: { vm.selectedTags.contains(tag.name) },
                                        set: { value in return }))
                        }
                        .padding(.trailing, half_spacing)
                        .padding(.bottom, half_spacing)
                    }
                }
                .padding(.horizontal, default_spacing)
                
                Spacer()
                
                Button {
                    presentTagSheet = false
                } label: {
                    Text("Apply")
                        .modifier(Header())
                        .frame(width: UIScreen.main.bounds.width / 2)
                }
                .padding(.top, half_spacing)
                .tint(Color.color_button_container_primary)
                .buttonStyle(.borderedProminent)
                
                Button {
                    withAnimation {
                        vm.selectedTags = []
                    }
                } label: {
                    Text("Clear")
                        .modifier(Link())
                        .frame(width: UIScreen.main.bounds.width / 2)
                }
                .padding(.top, half_spacing/2)
                .tint(Color.color_general_destructive)
                
            }
            .presentationDetents([.fraction(1/2.5), .medium, .large])
            .presentationDragIndicator(.visible)
        })
        .onAppear {
            vm.delegate = self
            vm.fetchData()
        }
        .navigationTitle("Search")
        .searchable(text: searchedText)
        .toolbar {
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
        SearchView()
    }
}
