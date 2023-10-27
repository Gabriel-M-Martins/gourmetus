//
//  CommunityRow.swift
//  Gourmetus
//
//  Created by Thiago Defini on 27/10/23.
//

import SwiftUI

struct CommunityRow: View {
    
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
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
            }
            
            VStack(alignment: .leading, spacing: 8){
                HStack{
                    Text(recipe.name)
                        .foregroundColor(.orange)
                        .font(.subheadline)
                        .lineLimit(1)
                    Spacer()
                }
                
                difficulty
                    .font(.subheadline)
                Text("\(Image(systemName: "star.fill")) \(recipe.difficulty.formatted())")
                    .font(.subheadline)
                    .foregroundStyle(.yellow)
                Text("By \(Image(systemName: "person.circle")) (Owner)")
                    .font(.footnote)
                    .foregroundStyle(.gray)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .frame(width: 357, height: 275)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.gray, lineWidth: 3)
        )
    }
}

#Preview {
    CommunityRow(recipe: Constants.mockedRecipe)
}

extension CommunityRow {
    
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
