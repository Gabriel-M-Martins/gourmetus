//
//  MyRecipesRow.swift
//  Gourmetus
//
//  Created by Thiago Defini on 26/10/23.
//

import SwiftUI

struct RecipeCardVerticalSmall: View {
    
    @StateObject var vm: RecipeCardVerticalSmallViewModel
    
    init(recipe: Recipe) {
        self._vm = StateObject(wrappedValue: RecipeCardVerticalSmallViewModel(recipe: recipe))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
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
                    .padding(.vertical, default_spacing)
                    .padding(.horizontal, default_spacing)
            }
            
            VStack(alignment: .leading, spacing: 8){
                Text(vm.recipe.name)
                    .modifier(Paragraph())
                    .lineLimit(1)
                    .foregroundColor(Color.color_button_container_primary)
                
                difficulty
                
                Text("By \(Image.personCircle)")
                    .modifier(Span())
                    .foregroundColor(Color.color_text_container_muted)
                    .lineLimit(1)
                
            }
            .padding(.horizontal, default_spacing)
            .padding(.bottom, default_spacing)
            
        }
        .frame(width: 212, height: 275)
        .cornerRadius(smooth_radius)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color.color_card_container_stroke, lineWidth: 2)
        )
    }
}

#Preview {
    RecipeCardVerticalSmall(recipe: Constants.mockedRecipe)
}

extension RecipeCardVerticalSmall {
    
    var difficulty: some View {
        HStack{
            ForEach(0..<Int(vm.recipe.difficulty)){ index in
                Image.knife
                    .foregroundColor(Color.color_text_container_highlight)
            }
        }
    }
    
}
