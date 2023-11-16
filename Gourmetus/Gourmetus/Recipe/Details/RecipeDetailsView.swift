//
//  RecipeDetailsView.swift
//  Gourmetus
//
//  Created by Thiago Defini on 24/10/23.
//

import SwiftUI

struct RecipeDetailsView: View {
    enum Destination {
        case Player
        case Edit
    }
    
    @StateObject var vm: RecipeDetailsViewModel = RecipeDetailsViewModel()
    @EnvironmentObject var cookbook: Cookbook
    
    var recipe: Recipe
    
    @State private var isNextViewActivated: Bool = false
    @State private var destination: Destination = .Player
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .center, spacing: default_spacing) {
                    Image.bookFavourites
                        .resizable()
                        .scaledToFill()
                        .frame(height: UIScreen.main.bounds.width/2.5)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: smooth_radius, height: smooth_radius)))
                    
                    
                    
                    VStack(alignment: .center, spacing: half_spacing) {
                        HStack(alignment: .top) {
                            Spacer()
                            
                            HStack {
                                Image.clockFill
                                Text(String(format: "%02d:%02d", recipe.duration/60, recipe.duration%60))
                            }
                            
                            Text("・")
                            
                            HStack {
                                Text("BY")
                                Image.personCircle
                                Text("YOU")
                            }
                            
                            Spacer()
                        }
                        .foregroundStyle(Color.color_text_container_muted)
                        
                        HStack(alignment: .center) {
                            Spacer()
                            
                            // TODO: foreach de dificuldade || componente de dificuldade
                            HStack {
                                KnifeView(recipe: recipe)
                            }
                            
                            Text("・")
                            
                            HStack {
                                Image.starFill
                                // TODO: Usar avaliação da receita
                                Text("4.0")
                            }
                            .foregroundStyle(Color.color_text_review_primary)
                            
                            Spacer()
                        }
                    }
                    .modifier(Span())
                    
                    // TODO: componente de resizable tag collection
                    
                    Divider()
                }
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
            
            if let description = recipe.desc {
                Section {
                    Text(description)
                } header: {
                    Text("Description")
                }
            }
            
            // TODO: Empty state de ingredients
            Section {
                ForEach(recipe.ingredients) { ingredient in
                    HStack {
                        Text(ingredient.name)
                        
                        Spacer()
                        
                        Text("\(ingredient.quantity) \(ingredient.unit.description)")
                            .foregroundStyle(Color.color_text_container_muted)
                    }
                }
            } header: {
                Text("Ingredients")
            }
            
            // TODO: Empty state de steps
            Section {
                ForEach(0..<recipe.steps.count) { idx in
                    HStack {
                        Text(recipe.steps[idx].title)
                            .foregroundStyle(Color.color_text_container_highlight)
                        
                        Spacer()
                        
                        Image.chevronRight
                            .foregroundColor(Color.color_button_container_primary)
                    }
                    .background(
                        // TODO: Ir para o player no passo escolhido
                        
                        NavigationLink(destination: RecipePlayerView(recipe: recipe, step: idx), label: {})
                    )
                }
            } header: {
                Text("Steps")
            }
            
            
            HStack {
                Spacer()
                
                Button(action: { 
                    isNextViewActivated = true
                    self.destination = .Player
                }) {
                    Text("Start")
                        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.075)
                        .foregroundStyle(Color.color_general_fixed_light)
                        .modifier(Header())
                    
                }
                .tint(.color_button_container_primary)
                .buttonStyle(.borderedProminent)
                .overlay(
                    GeometryReader { proxy in
                        Button("") {
                            cookbook.toggleFavourite(recipe: recipe)
                        }
                        .buttonStyle(FavoriteButtonStyle(isFavorited:
                                .init(get: { cookbook.isFavoritedRecipe(recipe: recipe) },
                                      set: { value in return }))
                        )
                        .position(x: proxy.frame(in: .local).width + half_spacing + UIScreen.main.bounds.width * 0.045, y: proxy.frame(in: .local).midY)
                    }
                )
                
                Spacer()
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
        }
        .toolbarRole(.editor)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    ForEach(RecipeDetailsViewModel.MenuOption.allCases, id: \.self) { option in
                        Button(role: option.isDestructive ? ButtonRole.destructive : nil) {
                            vm.menuButtonClicked(option)
                        } label: {
                            Text(option.description)
                        }
                    }
                } label: {
                    Image.ellipsisCircle
                        .foregroundStyle(Color.color_button_container_primary)
                }
            }
        })
        .navigationTitle(recipe.name)
        .navigationDestination(isPresented: $isNextViewActivated) {
            switch destination {
            case .Player:
                RecipePlayerView(recipe: recipe, step: 0)
            case .Edit:
                CreateEditRecipeView(recipe: recipe)
            }
            
        }
        .onAppear {
            self.vm.delegate = self
        }
    }
}

#Preview {
    NavigationStack {
        RecipeDetailsView(recipe: Constants.mockedRecipe)
    }
}

extension Binding {
    func toOptional() -> Binding<Value?> {
        return Binding<Value?> {
            self.wrappedValue
        } set: { val in
            self.wrappedValue = val ?? self.wrappedValue
        }
    }
}

extension RecipeDetailsView: RecipeDetailsDelegate {
    
    func editRecipe() {
        self.destination = .Edit
        self.isNextViewActivated = true
    }
}
