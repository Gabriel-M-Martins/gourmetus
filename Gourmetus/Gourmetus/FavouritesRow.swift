//
//  FavouritesRow.swift
//  Gourmetus
//
//  Created by Thiago Defini on 26/10/23.
//

import SwiftUI

struct FavouritesRow: View {
    
    var recipe: RecipeModel
    
    var body: some View {
        HStack{
            if let imgData = recipe.imageData,
               let img = UIImage(data: imgData) {
                Image(uiImage: img)
                    .resizable()
                    .cornerRadius(20)
                    .padding(.vertical, 20.5)
                    .padding(.horizontal, 16)
            }else{
                Image(systemName: "photo.fill")
                    .resizable()
                    .cornerRadius(20)
                    .padding(.vertical, 20.5)
                    .padding(.horizontal, 16)
            }
            
            VStack(alignment: .leading, spacing: 8){
                HStack{
                    Text(recipe.name)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(2)
                        .font(.subheadline)
                    Spacer()
                }
                
                difficulty
                    .font(.subheadline)
                Text("\(Image(systemName: "star.fill")) \(recipe.difficulty.formatted())")
                    .font(.subheadline)
                    .foregroundStyle(.yellow)
                Text("By \(Image(systemName: "person.circle")) (Owner)")
                    .font(.footnote)
            }
            .frame(width: 180)
            .padding(.vertical, 14.5)
            .padding(.trailing, 16)
        }
        .frame(width: 351, height: 136)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.orange, lineWidth: 3)
        )
        
    }
}

#Preview {
    FavouritesRow(recipe: Constants.mockedRecipe)
}

extension FavouritesRow {
    
    private func floatIsInteger(num: Float) -> Bool{
        if num.truncatingRemainder(dividingBy: 1) == 0 {
            return true
        }else{
            return false
        }
    }
    
    var difficulty: some View {
        HStack{
            ForEach(0..<Int(recipe.difficulty)){ index in
                Image(systemName: "frying.pan.fill")
                    .foregroundColor(.green)
            }
        }
    }
    
}
