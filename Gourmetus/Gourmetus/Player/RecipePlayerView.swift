//
//  RecipePlayerView.swift
//  Gourmetus
//
//  Created by Eduardo Dalencon on 30/10/23.
//

import SwiftUI

struct RecipePlayerView: View {
    
    @State var isTextFocused : Bool = false
    
    @State var isTipCollapsed : Bool = true
    
    @StateObject var playerViewModel: RecipePlayerViewModel
    
    
    init(recipe: Recipe, step: Int) {
        self._playerViewModel = StateObject(wrappedValue: RecipePlayerViewModel(recipe: recipe,initialStepIndex: step))
    }
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
       @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var isLandscape: Bool {
            return horizontalSizeClass == .compact && verticalSizeClass == .regular
        }
    
    var body: some View {
        
        
        GeometryReader { geometry in
            ZStack{
                VStack{
                    
                   
                    
                    VStack(spacing: 20){
                        
                        
                        VStack (spacing: 20){
                        
                            RotatingView(isLandscape: !isLandscape){
                            
                           
                                
                                if(playerViewModel.currentStep.tip != nil){
                                    
                                    HStack (alignment: .top){
                                        VStack{
                                            Text("TIP:")
                                            
                                        }
                                        
                                            .frame(width: 30)
                                            
                                        Text(playerViewModel.currentStep.tip!)
                                            .frame(maxWidth: .infinity,alignment: .leading)
                                            .if(isTipCollapsed) { $0.lineLimit(1) }
                                            .truncationMode(.tail)
                                        
                                        
                                        if(playerViewModel.currentStep.tip!.count > 35){
                                            Button {
                                                withAnimation {
                                                    isTipCollapsed.toggle()
                                                }
                                            } label: {
                                                Image(systemName: isTipCollapsed ? "chevron.down" : "chevron.up")
                                                    .padding(.top,5)
                                            }
                                        }
                                            
                                        
                                        
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.color_text_container_highlight)
                                    .foregroundColor(Color.brandWhite)
                                    .cornerRadius(hard_radius)
                                    //.animation(.easeInOut)
                                    
                                    
                                }
                                
                                if(playerViewModel.currentStep.imageData != nil && !isTextFocused){
                                    Image(uiImage: UIImage(data: playerViewModel.currentStep.imageData!)!)
                                        .resizable()
                                        //.aspectRatio(contentMode: .fill
                                        .frame(height: 160)
                                        .cornerRadius(hard_radius)
                                        .if(!isLandscape) { $0.frame(maxWidth: UIScreen.main.bounds.size.width * 0.3) }
                                        .if(isLandscape) { $0.frame(width: UIScreen.main.bounds.width - 40) }
                                }
                                
                                if(playerViewModel.currentStep.ingredients.count > 0){
                                    VStack{
                                       
                                        Text("Ingredients used in this step")
                                            .modifier(Span())
                                        Text(playerViewModel.concatenateIngredients())
                                            .modifier(Paragraph())
                                            .foregroundColor(Color.color_text_container_highlight)
                                       
                                    }
                                }
                              
                                
                            }
                            
                            
                            if(playerViewModel.currentStep.texto != nil){
                                Text(playerViewModel.currentStep.texto!)
                                    .modifier(Title())
                                    .fontWeight(.light)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        //.background(Color.red)
                        .padding(0)
                   
                    }
                    .frame(width: geometry.size.width)
                    //.padding(100)
                    
                    Spacer()
                    
                    
                }
                .padding(0)
                .transaction { transaction in
                    transaction.animation = nil
                }
                //.frame(height: geometry.size.height * 0.77)
                
                VStack (spacing:0){
                    Spacer()
                    VStack(spacing:0){
                        
                        if(playerViewModel.currentStep.timer != nil){
                            TimerView(remainingTime: playerViewModel.currentStep.timer!)
                        }
                        
                        HStack(spacing: 0){
                            //Previous Step
                            Button(action: {
                                withAnimation{
                                    playerViewModel.previousStep()
                                    }
                            }, label: {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 20)
                                    .foregroundColor(Color.black)
                                   
                                    
                            })
                            Spacer()
                            Text(playerViewModel.currentStep.title)
                                .modifier(Span())
                                .foregroundColor(Color.color_text_container_highlight)
                            Spacer()
                            //Next Step
                            Button(action: {
                                withAnimation{
                                    playerViewModel.nextStep()
                                }
                                   
                                
                            }, label: {
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 20)
                                    .foregroundColor(Color.black)
                                    
                            })
                            
                            
                        }
                        .padding(.vertical,2)
                        .padding(.horizontal, 15)
                        
                        HStack{
                            ForEach(0..<playerViewModel.recipe.steps.count, id: \.self) { page in
                                Circle()
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(page == playerViewModel.currentStepIndex ? Color.color_text_container_highlight : Color.gray)
                            }
                        }
                    }
                    //.background(Color.red)
                    .ignoresSafeArea()
                    .frame(width: UIScreen.main.bounds.size.width)
                    .padding()
                    .background {
                        UnevenRoundedRectangle(cornerRadii: .init(
                            topLeading: 50.0,
                            bottomLeading: 0,
                            bottomTrailing: 0,
                            topTrailing: 50.0),
                            style: .continuous)
                        .foregroundStyle(.white).ignoresSafeArea()
                        .shadow(color: Color.gray, radius: 5, x: 0, y: 2)
                    }
                    .toolbar(.hidden, for: .tabBar)
                    .navigationBarTitleDisplayMode(.inline)
                    .animation(.easeIn, value: 2)
                    
                }
                
                
               
            }
            .frame(width: geometry.size.width)
            .padding(0)
            //.ignoresSafeArea()
            
            
            
        }
        //.edgesIgnoringSafeArea(.all)
        //.ignoresSafeArea()
        //.background(Color.blue)
        .padding()
        .edgesIgnoringSafeArea(.bottom)
        .navigationTitle(playerViewModel.recipe.name)
        .toolbarRole(.editor)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    
                    Section("Display modes:"){
                        Button {
                                   isTextFocused = true
                        } label: {
                            HStack {
                                Text("Text Focused")
                                    .if(isTextFocused) { $0.background(Color.red) }
                                Spacer()
                                if(isTextFocused){
                                    Image(systemName: "checkmark")
                                }
                                   
                               
                            }
                        }
                        
                        Button {
                            isTextFocused = false
                        } label: {
                            HStack {
                                Text("Default")
                                    .if(!isTextFocused) { $0.bold() }
                                Spacer()
                                if(!isTextFocused){
                                    Image(systemName: "checkmark")
                                }
                               
                            }
                        }
                    }
                    
                    
                } label: {
                    Image.ellipsisCircle
                        .foregroundStyle(Color.color_button_container_primary)
                }
            }
        })
       
        
           
    }
    
        
}

#Preview {
    RecipePlayerView(recipe: Constants.mockedRecipe, step: 0)
}

struct RotatingView<Content:View>:View{
    let isLandscape: Bool
    @ViewBuilder var content:()->Content
    
    var body: some View{
        if(isLandscape){
            HStack(spacing: 20){
                content()
            }
        } else {
            VStack(spacing: 20){
                content()
            }
        }
    }
}

extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition { transform(self) }
        else { self }
    }
}
