//
//  CommunityRow.swift
//  Gourmetus
//
//  Created by Thiago Defini on 27/10/23.
//

import SwiftUI

struct RecipeCardVerticalBig: View {
    
    @Injected private var repo: any Repository<Cookbook>
    
    @StateObject var vm: RecipeCardVerticalBigViewModel
    
    @EnvironmentObject var cookbook: Cookbook
    
    init(recipe: Recipe) {
        self._vm = StateObject(wrappedValue: RecipeCardVerticalBigViewModel(recipe: recipe))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            if let imgData = vm.recipe.imageData,
               let img = UIImage(data: imgData) {
                Image(uiImage: img)
                    .resizable()
                    .cornerRadius(smooth_radius)
                    .padding(.top, default_spacing)
                    .padding(.horizontal, default_spacing)
            }else{
                Image("DefaultRecipeImage")
                    .resizable()
                    .cornerRadius(smooth_radius)
                    .padding(.top, default_spacing)
                    .padding(.horizontal, default_spacing)
                    .frame(height: 145)
            }
            ZStack {
                HStack{
                    VStack(alignment: .leading, spacing: 8){
                        
                        Text(vm.recipe.name)
                            .modifier(Paragraph())
                            .foregroundColor(Color.color_button_container_primary)
                            .lineLimit(1)
                        
                        KnifeView(recipe: vm.recipe)
                        
                        Text("\(Image.starFill) \(vm.recipe.difficulty.formatted())")
                            .modifier(Paragraph())
                            .foregroundStyle(Color.color_text_review_primary)
                        Text("By \(Image.personCircle)")
                            .modifier(Span())
                            .foregroundColor(Color.color_text_container_muted)
                            .truncationMode(.tail)
                            .lineLimit(1)
                            
                        
                    }
                    
                    Spacer()
                }
 
                VStack{
                    Spacer()
                    
                    HStack{
                        Spacer()
                        Button{
                            cookbook.favorites = vm.toggleFavourite(favorites: cookbook.favorites)
                            repo.save(cookbook)
                        }label: {
                            ZStack{
                                Circle()
                                    .fill(vm.isFavorite(favorites: cookbook.favorites) ? Color.color_button_container_primary : Color.color_background_container_primary)
                                    .modifier(cardShadow())
                                    .overlay(
                                        RoundedRectangle(cornerRadius: smooth_radius)
                                            .strokeBorder(.orange, lineWidth: 2)
                                    )
                                Image.heartFill
                                    .foregroundColor(vm.isFavorite(favorites: cookbook.favorites) ? Color.color_background_container_primary : Color.color_button_container_primary)
                                
                            }
                            .frame(width: 37, height: 36)
                        }
                    }
                }
            }

            .padding(.horizontal, default_spacing)
            .padding(.bottom, default_spacing)
            
        }
        .frame(width: 357, height: 260)
        .cornerRadius(smooth_radius)
        .overlay(
            RoundedRectangle(cornerRadius: smooth_radius)
                .strokeBorder(Color.color_card_container_stroke, lineWidth: 2)
        )
        
    }
}

extension RecipeCardVerticalBig {
    
    private func floatIsInteger(num: Float) -> Bool{
        if num.truncatingRemainder(dividingBy: 1) == 0 {
            return true
        }else{
            return false
        }
    }
    
}

#Preview {
    RecipeCardVerticalBig(recipe: Constants.mockedRecipe)
        .environmentObject(Constants.mockedCookbook)
}
