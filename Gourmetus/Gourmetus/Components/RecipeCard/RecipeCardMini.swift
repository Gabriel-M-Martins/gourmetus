//
//  RecentlyAccessedRow.swift
//  Gourmetus
//
//  Created by Thiago Defini on 25/10/23.
//

import SwiftUI

struct RecipeCardMini: View {
        
    @StateObject var vm: RecipeCardMiniViewModel
    
    init(recipe: RecipeModel) {
        self._vm = StateObject(wrappedValue: RecipeCardMiniViewModel(recipe: recipe))
    }
    
    var body: some View {
        VStack(alignment: .leading){
            if let imgData = vm.recipe.imageData,
               let img = UIImage(data: imgData) {
                Image(uiImage: img)
            }else{
                Image(systemName: "square")
                    .resizable()
                    .frame(width: 123, height: 60)
            }
            Text(vm.recipe.name)
                .font(.callout)
            Text("Status")
                .font(.footnote)
        }
        .frame(width: 123, height: 104)
    }
}

#Preview {
    RecipeCardMini(recipe: Constants.mockedRecipe)
}
