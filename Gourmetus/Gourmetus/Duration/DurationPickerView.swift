//
//  CreateEditIngredientView.swift
//  Gourmetus
//
//  Created by Eduardo Dalencon on 08/11/23.
//

import SwiftUI

class DurationPickerViewModel: ObservableObject {
    @Published var ingredientName = ""
    @Published var ingredientQuantity = ""
    @Published var ingredientUnit : IngredientUnit = .Kg
    
}

struct DurationPickerView: View {
    
    @ObservedObject var recipeViewModel:  CreateEditRecipeViewModel
    
    @Binding var showSheet: Bool
    
    var body: some View {
        
        VStack{
            
            HStack{
                Text("Set the duration")
                    .bold()
                
                Spacer()
                
                Button(action: {
                    
                    
                    showSheet.toggle()
                }, label: {
                    Text("Close")
                })
                
            }
            
            Spacer()
                .frame(height: 30)
            
            HStack {
                Picker("", selection: $recipeViewModel.hourSelection) {
                    ForEach(0..<24, id: \.self) { i in
                        Text("\(i) hour").tag(i)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                
                Picker("", selection: $recipeViewModel.minuteSelection) {
                    ForEach(0..<60, id: \.self) { i in
                        Text("\(i) min").tag(i)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
        }
        
        
        .padding()
        //.background(Color.gray)

    }
    
        
        
}

#Preview {
    CreateEditIngredientView( editingIngredient: .constant(Constants.mockedIngredients1[0]) , recipeViewModel: CreateEditRecipeViewModel(), showSheet: .constant(false))
}
