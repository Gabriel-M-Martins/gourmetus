//
//  RecipeDetailsView.swift
//  Gourmetus
//
//  Created by Thiago Defini on 24/10/23.
//

import SwiftUI

struct RecipeDetailsView: View {
    
    @Injected private var repo: any Repository<Cookbook>
    
    @StateObject var vm: RecipeDetailsViewModel
    
    @EnvironmentObject var cookbook: Cookbook
    
    init(recipe: Recipe) {
        self._vm = StateObject(wrappedValue: RecipeDetailsViewModel(recipe: recipe))
    }
    
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
                                Text("00:40 MIN")
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
                            
                            HStack {
                                // TODO: foreach de dificuldade || componente de dificuldade
                                Image.knife
                            }
                            
                            Text("・")
                            
                            HStack {
                                Image.starFill
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
            
            if let description = vm.recipe.desc {
                Section {
                    Text(description)
                } header: {
                    Text("Description")
                }
            }
            
            Section {
                ForEach(vm.recipe.ingredients) { ingredient in
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
            
            Section {
                ForEach(vm.recipe.steps) { step in
                    HStack {
                        Text(step.title)
                            .foregroundStyle(Color.color_text_container_highlight)
                        
                        Spacer()
                        
                        Image.chevronRight
                            .foregroundColor(Color.color_button_container_primary)
                    }
                    .background(
                        // TODO: Ir para o player no passo escolhido
                        NavigationLink(destination: RecipePlayerView(recipe: vm.recipe), label: {})
                    )
                }
            } header: {
                Text("Steps")
            }
            
        }
    }
}

#Preview {
    NavigationStack {
        RecipeDetailsView(recipe: Constants.mockedRecipe)
            .environmentObject(Cookbook())
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
