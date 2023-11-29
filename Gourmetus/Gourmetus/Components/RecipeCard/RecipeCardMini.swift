//
//  RecentlyAccessedRow.swift
//  Gourmetus
//
//  Created by Thiago Defini on 25/10/23.
//

import SwiftUI

struct RecipeCardMini: View {
    
    var recipe: Recipe
    
    //Versão certa
//        .resizable()
//        .scaledToFill()
//        .frame(height: 145)
//        .clipShape(RoundedRectangle(cornerRadius: smooth_radius))
//        .padding(.top, default_spacing)
//        .padding(.horizontal, default_spacing)
    
    //Antiga
//        .resizable()
////                    .scaledToFill()
//        .frame(height: 60)
//        .cornerRadius(hard_radius)
//        .overlay(
//            RoundedRectangle(cornerRadius: hard_radius)
//                .strokeBorder(Color.color_button_container_primary, lineWidth: 2)
//        )
    
    var body: some View {
        VStack(alignment: .leading, spacing: half_spacing){
            if let imgData = recipe.imageData,
               let img = UIImage(data: imgData) {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 123, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: hard_radius))
                    .overlay(
                        RoundedRectangle(cornerRadius: hard_radius)
                            .strokeBorder(Color.color_button_container_primary, lineWidth: 2)
                    )
            }else{
                Image("DefaultRecipeImage")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 123, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: hard_radius))
                    .overlay(
                        RoundedRectangle(cornerRadius: hard_radius)
                            .strokeBorder(Color.color_button_container_primary, lineWidth: 2)
                    )
                    
            }
            Text(recipe.name)
                .modifier(Paragraph())
                .lineLimit(1)
            if recipe.completed {
                Text("Completed")
                    .foregroundColor(Color.color_text_container_highlight)
                    .modifier(Paragraph())
            } else {
                Text("Continue")
                    .foregroundColor(Color.color_text_container_highlight)
                    .modifier(Paragraph())
            }
            
        }
        .frame(width: 123)
    }
}

#Preview {
    RecipeCardMini(recipe: Constants.mockedRecipe)
}
