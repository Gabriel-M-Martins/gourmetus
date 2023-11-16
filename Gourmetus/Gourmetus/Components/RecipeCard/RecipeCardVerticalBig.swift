//
//  CommunityRow.swift
//  Gourmetus
//
//  Created by Thiago Defini on 27/10/23.
//

import SwiftUI

struct RecipeCardVerticalBig: View {
    
    @State var recipe: Recipe
    @Binding var isFavorite: Bool
    
    var favoriteButtonClosure: () -> ()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            if let imgData = recipe.imageData,
               let img = UIImage(data: imgData) {
                Image(uiImage: img)
                    .resizable()
                    .cornerRadius(smooth_radius)
                    .padding(.top, default_spacing)
                    .padding(.horizontal, default_spacing)
            } else {
                Image("DefaultRecipeImage")
                    .resizable()
                    .cornerRadius(smooth_radius)
                    .padding(.top, default_spacing)
                    .padding(.horizontal, default_spacing)
                    .frame(height: 145)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: half_spacing){
                    Text(recipe.name)
                        .modifier(Paragraph())
                        .foregroundColor(Color.color_button_container_primary)
                        .lineLimit(1)
                    
//                    difficulty
                    
                    Text("\(Image.starFill) \(recipe.difficulty.formatted())")
                        .modifier(Paragraph())
                        .foregroundStyle(Color.color_text_review_primary)
                    Text("By \(Image.personCircle)")
                        .modifier(Span())
                        .foregroundColor(Color.color_text_container_muted)
                        .truncationMode(.tail)
                        .lineLimit(1)
                        
                    
                }
                
                Spacer()
                
                VStack {
                    Spacer()
                    
                    Button("botao") {
                        self.favoriteButtonClosure()
                    }
                    .buttonStyle(FavoriteButtonStyle(isFavorited: $isFavorite))
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
    RecipeCardVerticalBig(recipe: Constants.mockedRecipe, isFavorite: .constant(false), favoriteButtonClosure: {})
        .environmentObject(Constants.mockedCookbook)
}
