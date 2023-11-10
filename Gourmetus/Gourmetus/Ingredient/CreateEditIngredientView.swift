//
//  CreateEditIngredientView.swift
//  Gourmetus
//
//  Created by Eduardo Dalencon on 08/11/23.
//

import SwiftUI

struct CreateEditIngredientView: View {
    
    @StateObject var ingredientViewModel =  CreateEditIngredientViewModel()
    @Binding var editingIngredient: Ingredient?
    
    @State var texto : String = "texto"
    @State var unidade: IngredientUnit? = nil
    @State var notificationId: UUID? = nil
    
    @ObservedObject var recipeViewModel:  CreateEditRecipeViewModel
    
    @Binding var showSheet: Bool
    
    
    var body: some View {
        
        VStack{
            
            HStack{
                Text("Add Ingredient")
                    .bold()
                
                Spacer()
                
                Button(action: {
                    showSheet.toggle()
                    recipeViewModel.editingIngredient = nil
                    
                }, label: {
                    Text("Cancel")
                        .foregroundColor(.secondary)
                        
                })
                
                Button(action: {
                    
                    if (editingIngredient != nil){
                        
                        ingredientViewModel.updateIngredient(recipeViewModel: recipeViewModel, ingredient: editingIngredient!)
                    } else {
                        ingredientViewModel.addIngredient(recipeViewModel: recipeViewModel)
                    }
                    
                    showSheet.toggle()
                }, label: {
                    Text("Save")
                })
                
            }
            
            Spacer()
                .frame(height: 30)
            
            VStack{
                HStack{
                    Text("Ingredient")
                        .bold()
                    TextField("Enter ingredient", text: $ingredientViewModel.ingredientName)
                        
                }
                
                Divider()
                
                HStack{
                    Text("Quantity")
                        .bold()
                    TextField("Enter quantity", text: $ingredientViewModel.ingredientQuantity)
                        
                }
                
                Divider()
                
                HStack{
                    Text("Unit of Measurement")
                        .bold()
                    Spacer()
                    Picker("Unit", selection: $ingredientViewModel.ingredientUnit) {
                        ForEach(IngredientUnit.allCases) { unit in
                            Text(unit.description)
                            }
                    }
                    .pickerStyle(DefaultPickerStyle())
                        
                }
                
                
                
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
        }
        
        
        .padding()
        //.background(Color.gray)
        
        .onAppear(perform: {
           
            if (editingIngredient != nil){
                
                ingredientViewModel.editField(ingredient: editingIngredient!)
            }
        })
        
        
        
        
        
    }
    
        
        
}

#Preview {
    CreateEditIngredientView( editingIngredient: .constant(Constants.mockedIngredients[0]) , recipeViewModel: CreateEditRecipeViewModel(), showSheet: .constant(false))
}
