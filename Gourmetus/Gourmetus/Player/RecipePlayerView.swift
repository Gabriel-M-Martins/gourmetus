//
//  RecipePlayerView.swift
//  Gourmetus
//
//  Created by Eduardo Dalencon on 30/10/23.
//

import SwiftUI

//protocol RecipePlayerTimerDelegate {
//    func toggleTimer()
//    func resetTimer()
//    
//}

struct RecipePlayerView: View, PlayerDelegate {
    
    @State var isTextFocused : Bool = false
    
    @State var isTipCollapsed : Bool = true
    
    @State var showHelp: Bool = false
    
    @StateObject var playerViewModel: RecipePlayerViewModel
    @StateObject var speech = Speech()
    @StateObject var timerViewModel: TimerViewModel = TimerViewModel(initialTime: 10, id: UUID())
    
    @State var current = 0
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var cookbook: Cookbook
    
    init(recipe: Recipe, step: Int) {
        self._playerViewModel = StateObject(wrappedValue: RecipePlayerViewModel(recipe: recipe,initialStepIndex: step))
        self._timerViewModel = StateObject(wrappedValue: TimerViewModel(initialTime: recipe.steps[step].timer ?? 0, id: recipe.steps[step].id))
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
                                        
                                        //.frame(width: 30)
                                        
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
                
                VStack (spacing:0) {
                    Spacer()
                    VStack(spacing:0) {
                        
                        if(playerViewModel.currentStep.timer != nil){
                            if(playerViewModel.currentStep.timer != 0){
                                if(playerViewModel.currentStepIndex.isMultiple(of: 2)){
                                    TimerView(vm: timerViewModel)
                                        .onAppear {
                                            self.timerViewModel.initialTime = self.playerViewModel.currentStep.timer!
                                            self.timerViewModel.id = self.playerViewModel.currentStep.id
                                        }
                                } else{
                                    TimerView(vm: timerViewModel)
                                        .onAppear {
                                            self.timerViewModel.initialTime = self.playerViewModel.currentStep.timer!
                                            self.timerViewModel.id = self.playerViewModel.currentStep.id
                                        }
                                }
                            }
                        }
                        
                        if(playerViewModel.currentStepIndex == (playerViewModel.recipe.steps.count - 1)){
                            Button(action: {
                                
                                
                                playerViewModel.completeRecipe()
                                dismiss()
                                
                            }, label: {
                                Text("Finish")
                                
                                    .padding(.vertical, 7)
                                    .padding(.horizontal, 50)
                                
                                    .background(Color.color_button_container_primary)
                                    .cornerRadius(hard_radius)
                                    .foregroundColor(Color.color_general_fixed_light)
                                    .modifier(Header())
                                
                                
                            })
                        }
                        
                        HStack(spacing: 0){
                            //Previous Step
                            Button(action: {
                             
                                
                                withAnimation{
                                    playerViewModel.previousStep()
                                    
                                }
                                if(playerViewModel.recipe.steps[playerViewModel.currentStepIndex].timer != 0){
                                    timerViewModel.resetVM(initialTime: playerViewModel.recipe.steps[playerViewModel.currentStepIndex].timer ?? 0, id: playerViewModel.recipe.steps[playerViewModel.currentStepIndex].id)
                                }
                                

                            }, label: {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 20)
                                    .foregroundColor(Color.color_text_container_primary)
                                
                                
                            })
                            Spacer()
                            Text(LocalizedStringKey(playerViewModel.currentStep.title))
                                .modifier(Span())
                                .foregroundColor(Color.color_text_container_highlight)
                            Spacer()
                            //Next Step
                            
                            Button(action: {
                               
                               
                                
                                withAnimation{
                                    playerViewModel.nextStep()
                                }
                                
                                if(playerViewModel.recipe.steps[playerViewModel.currentStepIndex].timer != 0){
                                    timerViewModel.resetVM(initialTime: playerViewModel.recipe.steps[playerViewModel.currentStepIndex].timer ?? 0, id: playerViewModel.recipe.steps[playerViewModel.currentStepIndex].id)
                                }
                                
                                
                                
                            }, label: {
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 20)
                                //.foregroundColor(Color.black)
                                    .if(playerViewModel.currentStepIndex != (playerViewModel.recipe.steps.count - 1)) { $0.foregroundColor(Color.color_text_container_primary) }
                                    .if(playerViewModel.currentStepIndex == (playerViewModel.recipe.steps.count - 1)) { $0.foregroundColor(Color.gray) }
                                
                            })
                            
                            
                        }
                        .padding(.vertical,2)
                        .padding(.horizontal, 15)
                        
                        HStack{
                            ForEach(0..<playerViewModel.recipe.steps.count, id: \.self) { page in
                                Circle()
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(page == playerViewModel.currentStepIndex ? Color.color_text_container_highlight : Color.color_card_container_stroke)
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
                        .foregroundStyle(Color(UIColor.secondarySystemGroupedBackground)).ignoresSafeArea()
                        .shadow(color: Color.gray, radius: 5, x: 0, y: 2)
                    }
                    .toolbar(.hidden, for: .tabBar)
                    .navigationBarTitleDisplayMode(.inline)
                    .animation(.easeIn, value: 2)
                    
                }
                
                //                if speech.showOverlay {
                //
                //                    ZStack{
                //                        Rectangle()
                //                            .opacity(0.5)
                //                        VStack{
                //                            Spacer()
                //                            Rectangle()
                //                                .foregroundColor(.white)
                //                                .frame(height: 300)
                //                                .overlay {
                //
                //                                    Text(speech.recognizedText)
                //                                }
                //                            Spacer()
                //                        }
                //                    }
                //                }
                
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
        .overlay {
                VStack{
                    HStack{
                        Spacer()
                        if speech.showOverlay || showHelp{
                            VoiceCommandView(speechStatus: $speech.status, text: $speech.recognizedText, showHelp: $showHelp)
                                .transition(.move(edge: .trailing))
//
                                
                        } else {
                            VoiceCommandView(speechStatus: $speech.status, text: $speech.recognizedText, showHelp: $showHelp)
                                .opacity(0)
                        }
                    }
                    .animation(.spring, value: speech.showOverlay)
                    
                    
                    if showHelp {
                        CommandsListView(showHelp: $showHelp)
                    }
                    
                    Spacer()
                    
                }
                .padding(.top, default_spacing)
                
        }

        
        .onAppear{
            speech.toggleRecording()
            self.playerViewModel.delegate = self
            self.speech.delegateView = self
            
        }
        
        .onDisappear{
            speech.stopRecording()
        }
        
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

extension RecipePlayerView: SpeechViewDelegate {
    
    func next() {
        print("next")
        self.playerViewModel.nextStep()
    }
    
    func previous() {
        print("previous")
        self.playerViewModel.previousStep()
    }
    
    func finish() {
        if self.playerViewModel.currentStepIndex == playerViewModel.recipe.steps.count - 1 {
            print("finish")
            self.playerViewModel.completeRecipe()
            dismiss()
        }
    }
    
    func first() {
        print("firstStep")
        self.playerViewModel.firstStep()
    }
    
    func last() {
        print("lastStep")
        self.playerViewModel.lastStep()
    }
    
    func quit() {
        print("quit")
        dismiss()
    }
    
    func mode() {
        print("mode")
        self.isTextFocused.toggle()
    }
    
    func timer() {
        timerViewModel.toggleTimer()
    }
    
    func timerReset() {
        print("timerReset")
        timerViewModel.resetTimer()
    }
    
    func tip() {
        print("tip")
        
        self.isTipCollapsed.toggle()
    }
    
    func help() {
        print("help")
        
        self.showHelp.toggle()
    }
}
