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
    
    private var image: Image {
        if let imgData = recipe.imageData,
           let img = UIImage(data: imgData) {
            return Image(uiImage: img)
        }
        
        return Image("DefaultRecipeImage")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            image
                .resizable()
                .scaledToFill()
                .clipped()
                .cornerRadius(smooth_radius)

            HStack {
                VStack(alignment: .leading, spacing: half_spacing) {
                    Spacer()
                    
                    Text(recipe.name)
                        .modifier(Paragraph())
                        .foregroundColor(Color.color_button_container_primary)
                        .lineLimit(1)
                    
                    KnifeView(recipe: recipe)
                    
                    Text("\(Image.starFill) \(recipe.rating == 0 ? String("No Ratings") : String(format: "%.1f", recipe.rating))")
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
        }
        .padding(default_spacing)
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
