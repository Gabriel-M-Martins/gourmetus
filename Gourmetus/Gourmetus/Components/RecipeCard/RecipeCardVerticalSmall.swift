//
//  MyRecipesRow.swift
//  Gourmetus
//
//  Created by Thiago Defini on 26/10/23.
//

import SwiftUI

struct RecipeCardVerticalSmall: View {
    
    var recipe: RecipeModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            if let imgData = recipe.imageData,
               let img = UIImage(data: imgData) {
                Image(uiImage: img)
                    .resizable()
                    .cornerRadius(20)
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
            }else{
                Image(systemName: "photo.fill")
                    .resizable()
                    .cornerRadius(20)
                    .padding(.vertical, 20.5)
                    .padding(.horizontal, 16)
            }
                Text(recipe.name)
                    .font(.callout)
                    .lineLimit(1)
                    .padding(.horizontal, 16)
                    .foregroundColor(.orange)
                
                difficulty
                    .font(.callout)
                    .padding(.horizontal, 16)
                
                Text("By (Owner)")
                    .font(.subheadline)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    .foregroundColor(.gray)

                
            
        }
        .frame(width: 212, height: 275)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.orange, lineWidth: 3)
        )
    }
}

#Preview {
    RecipeCardVerticalSmall(recipe: Constants.mockedRecipe)
}

extension RecipeCardVerticalSmall {
 
    var difficulty: some View {
        HStack{
            ForEach(0..<Int(recipe.difficulty)){ index in
                Image(systemName: "frying.pan.fill")
                    .foregroundColor(.green)
            }
        }
    }
    
}
