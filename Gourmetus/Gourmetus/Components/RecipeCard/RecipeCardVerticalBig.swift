//
//  CommunityRow.swift
//  Gourmetus
//
//  Created by Thiago Defini on 27/10/23.
//

import SwiftUI

struct RecipeCardVerticalBig: View {
    
    @Injected private var repo: any Repository<Cookbook>
    
    @StateObject var vm: RecipeCardVerticalBigViewModel
    
    @EnvironmentObject var cookbook: Cookbook
    
    init(recipe: Recipe) {
        self._vm = StateObject(wrappedValue: RecipeCardVerticalBigViewModel(recipe: recipe))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            if let imgData = vm.recipe.imageData,
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
                    Text(vm.recipe.name)
                        .foregroundColor(.orange)
                        .font(.subheadline)
                        .lineLimit(1)
                    Spacer()
                }
                
                difficulty
                    .font(.subheadline)
                Text("\(Image(systemName: "star.fill")) \(vm.recipe.difficulty.formatted())")
                    .font(.subheadline)
                    .foregroundStyle(.yellow)
                HStack{
                    Text("By \(Image(systemName: "person.circle")) (Owner)")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                    
                    Spacer()
                    Button{
                        cookbook.favorites = vm.toggleFavourite(recipe: vm.recipe, favorites: cookbook.favorites)
                        repo.save(cookbook)
                    }label: {
                        ZStack{
                            Circle()
                                .fill(vm.isFavorite(favorites: cookbook.favorites) ? .orange : .white)
                                .shadow(radius: 5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.orange, lineWidth: 3)
                                )
                                
                            Image(systemName: "heart.fill" )
                                .foregroundColor(vm.isFavorite(favorites: cookbook.favorites) ? .white : .orange)

                            
                        }
                        .foregroundColor(.orange)
                    }
                }
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
    RecipeCardVerticalBig(recipe: Constants.mockedRecipe)
}

extension RecipeCardVerticalBig {
    
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
                Image(systemName: "frying.pan.fill")
                    .foregroundColor(.green)
            }
        }
    }
    
}
