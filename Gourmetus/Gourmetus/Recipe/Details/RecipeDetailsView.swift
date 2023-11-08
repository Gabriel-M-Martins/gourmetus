//
//  RecipeDetailsView.swift
//  Gourmetus
//
//  Created by Thiago Defini on 24/10/23.
//

import SwiftUI

struct RecipeDetailsView: View {
    
    @StateObject var vm: RecipeDetailsViewModel
    
    init(recipe: Recipe, homeViewModel: HomeViewModel) {
        self._vm = StateObject(wrappedValue: RecipeDetailsViewModel(recipe: recipe, homeViewModel: homeViewModel))
    }
    
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
                        
                        ingredients
                    }
                    HStack{
                        NavigationLink{
                            CreateEditRecipeView(recipe: $vm.recipe.toOptional())
                        }label: {
                            Text("Editar")
                        }
                        NavigationLink{
                            //Action goes here
                            RecipePlayerView(recipe: vm.recipe)
                        }label: {
                            Text("Start")
                                .frame(width: 150, height: 40)
                                .background(.green)
                                .cornerRadius(5)
                                .foregroundColor(.black)
                            
                        }
                        
                        Button{
                            vm.homeViewModel.toggleFavourite(recipe: vm.recipe)
                            //Action goes here
                        }label: {
                            Image(systemName: vm.homeViewModel.isFavorited(recipe: vm.recipe) ? "heart.fill" : "heart")
                        }
                        .buttonStyle(.bordered)
//                        .padding(.leading, 250)
                        
                    }
                    .padding()
                    .navigationTitle(vm.recipe.name)
                }
                .padding()
            }
        }
        .onAppear{
           
        }
    }
}

#Preview {
    RecipeDetailsView(recipe: Constants.mockedRecipe, homeViewModel: HomeViewModel())
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
        
        if let imgData = vm.recipe.imageData,
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
    
    private var owner: some View {
        HStack{
            Text("Por (Nome da pessoa)")
                .padding(.horizontal)
                .padding(.bottom, 8)
            Spacer()
        }
    }
    
    private var tags: some View {
        HStack{
            Text("(Tag1) (Tag2) (Tag3)")
                .padding(.horizontal)
                .padding(.bottom)
            Spacer()
        }
    }
    
    private var ingredients: some View {
        ForEach(vm.recipe.ingredients) { ingredient in
            HStack{
                Text("\(ingredient.quantity) \(ingredient.unit.description) x \(ingredient.name)")
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                Spacer()
            }
        }
    }
    
    
}

extension Binding {
    func toOptional() -> Binding<Value?> {
        return Binding<Value?> {
            self.wrappedValue
        } set: { val in
            self.wrappedValue = val ?? self.wrappedValue
        }
    }
}
