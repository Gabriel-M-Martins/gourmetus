//
//  KnifeView.swift
//  Gourmetus
//
//  Created by Thiago Defini on 13/11/23.
//

import SwiftUI

struct KnifeView: View {
    
    var recipe: Recipe
    
    var body: some View {
        HStack{
            ForEach(0..<Int(recipe.difficulty)){ index in
                Image.knife
                    .foregroundColor(Color.color_text_container_highlight)
            }
        }
    }
}

#Preview {
    KnifeView(recipe: Constants.mockedRecipe)
}
