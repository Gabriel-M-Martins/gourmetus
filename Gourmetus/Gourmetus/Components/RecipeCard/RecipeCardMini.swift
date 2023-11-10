//
//  RecentlyAccessedRow.swift
//  Gourmetus
//
//  Created by Thiago Defini on 25/10/23.
//

import SwiftUI

struct RecipeCardMini: View {
        
    @StateObject var vm: RecipeCardMiniViewModel
    
    init(recipe: Recipe) {
        self._vm = StateObject(wrappedValue: RecipeCardMiniViewModel(recipe: recipe))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: half_spacing){
            if let imgData = vm.recipe.imageData,
               let img = UIImage(data: imgData) {
                Image(uiImage: img)
                    .resizable()
//                    .scaledToFill()
                    .frame(height: 60)
//                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(hard_radius)
                    .overlay(
                        RoundedRectangle(cornerRadius: hard_radius)
                            .strokeBorder(Color.color_button_container_primary, lineWidth: 2)
                    )
            }else{
                Image("DefaultRecipeImage")
                    .resizable()
//                    .scaledToFill()
                    .frame(height: 60)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(hard_radius)
                    .overlay(
                        RoundedRectangle(cornerRadius: hard_radius)
                            .strokeBorder(Color.color_button_container_primary, lineWidth: 2)
                    )
                    
            }
            Text(vm.recipe.name)
                .modifier(Paragraph())
                .lineLimit(1)

            Text("Completed")
                .foregroundColor(Color.color_text_container_highlight)
                .modifier(Paragraph())
        }
        .frame(width: 123)
    }
}

#Preview {
    HomeView()
        .environmentObject(Constants.mockedCookbook)
}
