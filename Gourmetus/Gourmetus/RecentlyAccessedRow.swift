//
//  RecentlyAccessedRow.swift
//  Gourmetus
//
//  Created by Thiago Defini on 25/10/23.
//

import SwiftUI

struct RecentlyAccessedRow: View {
    
    var recipe: RecipeModel
    
    var body: some View {
        VStack(alignment: .leading){
            if let imgData = recipe.imageData,
               let img = UIImage(data: imgData) {
                Image(uiImage: img)
            }else{
                Image(systemName: "square")
                    .resizable()
                    .frame(width: 123, height: 60)
            }
            Text(recipe.name)
                .font(.callout)
            Text("Status")
                .font(.footnote)
        }
        .frame(width: 123, height: 104)
    }
}

#Preview {
    RecentlyAccessedRow(recipe: Constants.mockedRecipe)
}
