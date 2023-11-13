//
//  FavouritesRow.swift
//  Gourmetus
//
//  Created by Thiago Defini on 26/10/23.
//

import SwiftUI

struct RecipeCardHorizontal: View {
    
    @StateObject var vm: RecipeCardHorizontalViewModel
    
    init(recipe: Recipe) {
        self._vm = StateObject(wrappedValue: RecipeCardHorizontalViewModel(recipe: recipe))
    }
    
    var body: some View {
        HStack{
            if let imgData = vm.recipe.imageData,
               let img = UIImage(data: imgData) {
                Image(uiImage: img)
                    .resizable()
                    .cornerRadius(smooth_radius)
                    .padding(.vertical, 20.5)
                    .padding(.horizontal, default_spacing)
            }else{
                Image("DefaultRecipeImage")
                    .resizable()
                    .cornerRadius(smooth_radius)
                    .padding(.vertical, 20.5)
                    .padding(.horizontal, default_spacing)
                
            }
            
            VStack(alignment: .leading, spacing: 8){
                HStack{
                    Text(vm.recipe.name)
                        .modifier(Paragraph())
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        
                    Spacer()
                }
                difficulty
                    .font(.subheadline)
                Text("\(Image.starFill) \(vm.recipe.difficulty.formatted())")
                    .modifier(Paragraph())
                    .foregroundStyle(Color.color_text_review_primary)
                Text("By \(Image.personCircle)")
                    .modifier(Paragraph())
                    .foregroundColor(Color.color_text_container_muted)
                    .lineLimit(1)
            }
            .frame(width: 180)
            .padding(.vertical, 14.5)
            .padding(.trailing, default_spacing)
        }
        .frame(width: 351, height: 136)
        .cornerRadius(smooth_radius)
        .overlay(
            RoundedRectangle(cornerRadius: smooth_radius)
                .strokeBorder(Color.color_button_container_primary, lineWidth: 2)
        )
        
    }
}

#Preview {
    RecipeCardHorizontal(recipe: Constants.mockedRecipe)
}

extension RecipeCardHorizontal {
    
    private func floatIsInteger(num: Float) -> Bool{
        if num.truncatingRemainder(dividingBy: 1) == 0 {
            return true
        }else{
            return false
        }
    }
    
    var difficulty: some View {
        HStack{
            ForEach(0..<Int(vm.recipe.difficulty)){ index in
                Image.knife
                    .foregroundColor(Color.color_text_container_highlight)
            }
        }
    }
    
}
