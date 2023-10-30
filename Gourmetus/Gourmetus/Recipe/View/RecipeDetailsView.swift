//
//  RecipeDetailsView.swift
//  Gourmetus
//
//  Created by Thiago Defini on 24/10/23.
//

import SwiftUI

struct RecipeDetailsView: View {
    
    var recipe: RecipeModel
    
    @State var isFavorited: Bool = false
    
    var body: some View {
        NavigationStack{
            GeometryReader{ reader in
                VStack{
                    ScrollView{
                        HStack{
                            image
                            VStack{
                                HStack(alignment: .bottom) {
                                    //difficulty
                                    Text("texto")
                                        .padding(.bottom)
                                }
                            }
                        }
                        //                    owner
                        //                    tags
                        
                        HStack{
                            Text("Ingredients")
                                .font(.title2)
                                .padding(.horizontal)
                            Spacer()
                        }
                        
                        //ingredients
                    }
                    ZStack{
                        Button{
                            //Action goes here
                        }label: {
                            Text("Start")
                                .frame(width: 150, height: 40)
                                .background(.green)
                                .cornerRadius(5)
                                .foregroundColor(.black)
                            
                        }
                        
                        Button{
                            isFavorited.toggle()
                            //Action goes here
                        }label: {
                            Image(systemName: isFavorited ? "heart.fill" : "heart")
                        }
                        .buttonStyle(.bordered)
                        .padding(.leading, 250)
                        
                    }
                    .padding()
                    .navigationTitle(recipe.name)
                }
                .padding()
            }
        }
    }
}

struct RecipeDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailsView(recipe: Constants.mockedRecipe)
    }
}

extension RecipeDetailsView {
    
    private func floatIsInteger(num: Float) -> Bool{
        if num.truncatingRemainder(dividingBy: 1) == 0 {
            return true
        }else{
            return false
        }
    }
    
    private var image: some View {
        
        if let imgData = recipe.imageData,
           let img = UIImage(data: imgData){
            return Image(uiImage: img)
                .resizable()
                .frame(width: 180,height: 100)
                .padding()
        } else {
            return Image(systemName: "square.fill")
                .resizable()
                .frame(width: 180,height: 100)
                .padding()
        }
    }
    
//    private var difficulty: some View {
//        ForEach(1..<6){ index in
//            if index < recipe.difficulty {
//                Image(systemName: "star.fill")
//                    .foregroundColor(.yellow)
//            } else if index == Int(recipe.difficulty) && !floatIsInteger(num: recipe.difficulty) && index != 5{
//                HStack {
//                    Image(systemName: "star.fill")
//                        .foregroundColor(.yellow)
//                    Image(systemName: "star.leadinghalf.filled")
//                        .foregroundColor(.yellow)
//                    ForEach(index+2..<6){ index2 in
//                        Image(systemName: "star")
//                            .foregroundColor(.yellow)
//                    }
//            }else if index == Int(recipe.difficulty) && floatIsInteger(num: recipe.difficulty) {
//                HStack {
//                    Image(systemName: "star.fill")
//                        .foregroundColor(.yellow)
//                    ForEach(index+1..<6){ index3 in
//                        Image(systemName: "star")
//                            .foregroundColor(.yellow)
//                    }
//                }
//            }else{
//                Text("Error")
//            }
//            
//        }
//    }
//    
//    private var owner: some View {
//        HStack{
//            Text("Por (Nome da pessoa)")
//                .padding(.horizontal)
//                .padding(.bottom, 8)
//            Spacer()
//        }
//    }
//    
//    private var tags: some View {
//        HStack{
//            Text("(Tag1) (Tag2) (Tag3)")
//                .padding(.horizontal)
//                .padding(.bottom)
//            Spacer()
//        }
//    }
//    
//    private var ingredients: some View {
//        ForEach(recipe.ingredients) { ingredient in
//            HStack{
//                Text("\(ingredient.quantity) \(ingredient.unit.description) x \(ingredient.name)")
//                    .padding(.horizontal)
//                    .padding(.vertical, 8)
//                Spacer()
//            }
//        }
//    }
//    
//    
}
