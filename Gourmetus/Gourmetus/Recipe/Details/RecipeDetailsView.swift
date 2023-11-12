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
            
            Section {
                // TODO: Usar infos da recipe
                Text(
                    """
                    A sweet and delicious shortbread recipe that is easy to make. Get your ingredients ready and let's start cooking this delicious biscuit that is loved by many all around the world!

                    If you like our recipes, check out our profile to view more of what we have made.

                    This recipe is beginner friendly, so any skill level can take a shot at it.
                    """
                )
            } header: {
                Text("Description")
            }
            
            Section {
                // TODO: ForEach ingredient in ingredients da recipe
                HStack {
                    Text("Coe")
                    
                    Spacer()
                    
                    Text("Tantos kg")
                        .foregroundStyle(Color.color_text_container_muted)
                }
            } header: {
                Text("Ingredients")
            }
            
            Section {
                // TODO: ForEach step in steps da recipe
                HStack {
                    Text("Let's start the recipe")
                        .foregroundStyle(Color.color_text_container_highlight)
                    
                    Spacer()
                    
                    Image.chevronRight
                        .foregroundColor(Color.color_button_container_primary)
                }
            } header: {
                Text("Steps")
            }
            
        }
    }
}

#Preview {
    RecipeDetailsView(recipe: Constants.mockedRecipe)
        .environmentObject(Cookbook())
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
