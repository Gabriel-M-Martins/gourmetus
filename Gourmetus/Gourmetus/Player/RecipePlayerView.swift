//
//  RecipePlayerView.swift
//  Gourmetus
//
//  Created by Eduardo Dalencon on 30/10/23.
//

import SwiftUI

struct RecipePlayerView: View {
    
    @StateObject var playerViewModel: RecipePlayerViewModel
    
    init(recipe: RecipeModel) {
        self._playerViewModel = StateObject(wrappedValue: RecipePlayerViewModel(recipe: recipe))
    }
    
    var body: some View {
        VStack(spacing: 20){
            if(playerViewModel.currentStep.imageData != nil){
                Image(uiImage: UIImage(data: playerViewModel.currentStep.imageData!)!)
                    .resizable()
                    .frame(width: 200, height: 120)
            }
            
            if(playerViewModel.currentStep.texto != nil){
                Text(playerViewModel.currentStep.texto!)
            }
            
            if(playerViewModel.currentStep.tip != nil){
                Text(playerViewModel.currentStep.tip!)
            }
            
        }
        
        Spacer()
        
        VStack{
            
            if(playerViewModel.currentStep.timer != nil){
                TimerView(remainingTime: playerViewModel.currentStep.timer!)
                
               
            }
            
            HStack(spacing: 10){
                //Previous Step
                Button(action: {
                    playerViewModel.previousStep()
                }, label: {
                    Text("Previous Step")
                        .frame(width: 120)
                        .padding(10)
                        .background(Color(.orange))
                        .cornerRadius(5)
                        .foregroundColor(.white)
                        .frame(width: 150)
                        
                })
                
                //Next Step
                Button(action: {
                    playerViewModel.nextStep()
                }, label: {
                    Text("Next Step")
                        .frame(width: 120)
                        .padding(10)
                        .background(Color(.orange))
                        .cornerRadius(5)
                        .foregroundColor(.white)
                })
                
                
            }
            
            HStack{
                ForEach(0..<playerViewModel.recipe.steps.count, id: \.self) { page in
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(page == playerViewModel.currentStepIndex ? Color.blue : Color.white)
                }
            }
        }
        .frame(width: 500)
        .padding()
        .background(Color(.gray))
           
    }
}

#Preview {
    RecipePlayerView(recipe: Constants.mockedRecipe)
}
