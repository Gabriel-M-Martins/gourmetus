//
//  CreateEditStepView.swift
//  Gourmetus
//
//  Created by Eduardo Dalencon on 26/10/23.
//

import SwiftUI
import PhotosUI

struct CreateEditStepView: View {
    
    var menu = ["Image","Text","Tip","Ingredient","Timer"]
    @Binding var editingStep: Step?
    var ingredients: [Ingredient] = [
        Ingredient(id: UUID(), name: "Farinha", quantity: "0.5", unit: .Kg),
        Ingredient(id: UUID(), name: "Ovo", quantity: "3", unit: .L)
    ]
    @StateObject private var imageViewModel = PhotoPickerViewModel()
    @StateObject var stepViewModel =  CreateEditStepViewModel()
    @ObservedObject var recipeViewModel:  CreateEditRecipeViewModel
    @Binding var showSheet: Bool
    @State private var selection: String?
    
    var emptyF: Bool {
        imageViewModel.selectedImage == nil && stepViewModel.texto.isEmpty && stepViewModel.tip.isEmpty && ingredients.isEmpty && stepViewModel.totalTime != 0
    }
 
    var body: some View {
        
        VStack{
            VStack(alignment: .leading, spacing:16) {
                HStack() {
                    Text("Title")
                        .font(.headline)
                    TextField("Step Title", text: $stepViewModel.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                Spacer()
                ScrollView{
                    if(emptyF == true){
                        Text("Add a component into the editor to build your step.")
                    }else{
                        if(imageViewModel.selectedImage != nil){
                            Image(uiImage: imageViewModel.selectedImage!)
                                .resizable()
                                .cornerRadius(8)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 360, height: 100)
                                .foregroundColor(.red)
                                .background(Color.gray)
                        }
                        
                        PhotosPicker(selection: $imageViewModel.imageSelecion,
                                     matching: .any(of: [.images, .not(.screenshots)])) {
                            Text("Select Photos")
                        }
                        
                        
                        if(!stepViewModel.texto.isEmpty){
                            TextField("Enter text", text: $stepViewModel.texto)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        if(!ingredients.isEmpty){
                            VStack(alignment: .leading){
                                Text("Ingredients")
                                    .foregroundStyle(.gray)
                                    .padding(.bottom,-12)
                                    .padding(.top,6)
                                    .padding(.leading,16)
                                HStack{
                                    ForEach(ingredients) { ingredient in
                                        Text(ingredient.name)
                                            .padding(6)
                                            .background(.green, in: .rect(cornerRadius: 6))
                                    }
                                    Spacer()
                                }
                                .padding()
                            }
                            .background(.white)
                        }
                        
                        if(!stepViewModel.tip.isEmpty){
                            TextField("Enter tip", text: $stepViewModel.tip)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        if(stepViewModel.totalTime != 0){
                            VStack(alignment: .leading) {
                                TimePicker(totalTime: $stepViewModel.totalTime)
                            }
                        }
                    }
                }
                .padding()
                .background(.gray)
                
                VStack(alignment: .leading) {
                    Text("Components")
                        .bold()
                        .foregroundStyle(.gray)
                    Divider()
                    List(menu, id: \.self){ option in
                        HStack {
                            Text(option)
                            Spacer()
                            Button(action: {
                                
                            }, label: {
                                Text("Add")
                                    .foregroundStyle(.orange)
                            })
                        }
                    }
                    .listStyle(.plain)
                    .frame(height:250)
                }
                .padding(.leading)
                
            }
                
        }
        .padding()
        .onAppear(perform: {
           
            if (editingStep != nil){
                if let image = editingStep!.imageData{
                    imageViewModel.selectedImage = UIImage(data: image)
                }
                stepViewModel.editField(step: editingStep!)
            } else {
                stepViewModel.texto = ""
                stepViewModel.tip = ""
                imageViewModel.selectedImage = UIImage()
            }
        })
    }
    
}

#Preview {
    CreateEditStepView(editingStep: .constant(Constants.mockedSteps[0]), recipeViewModel: CreateEditRecipeViewModel(), showSheet: .constant(false))
}


struct TimePicker: View {
    @Binding var totalTime: Int?
    @State var selectedHour: Int = 0
    @State var selectedMinute: Int = 0
    @State private var isHourPickerVisible = false
    @State private var isMinutePickerVisible = false

    var body: some View {
        VStack {
            HStack {
                Text("Hour: \(selectedHour) hours")
                Spacer()
                Button(action: {
                    isHourPickerVisible.toggle()
                }) {
                    Text("Select Hour")
                }
            }
            .padding()
            .onTapGesture {
                isHourPickerVisible.toggle()
            }

            if isHourPickerVisible {
                Picker("", selection: $selectedHour) {
                    ForEach(0..<24, id: \.self) { i in
                        Text("\(i) hours").tag(i)
                    }
                }
                .pickerStyle(DefaultPickerStyle())
            }

            HStack {
                Text("Minute: \(selectedMinute) min")
                Spacer()
                Button(action: {
                    isMinutePickerVisible.toggle()
                }) {
                    Text("Select Minute")
                }
            }
            .padding()
            .onTapGesture {
                isMinutePickerVisible.toggle()
            }

            if isMinutePickerVisible {
                Picker("", selection: $selectedMinute) {
                    ForEach(0..<60, id: \.self) { i in
                        Text("\(i) min").tag(i)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
        }
        .onChange(of: selectedHour, perform: { newHour in
            updateTotalTimeInMinutes()
        })
        .onChange(of: selectedMinute, perform: { newMinute in
            updateTotalTimeInMinutes()
        })
        .onAppear {
            if let timer = totalTime{
                selectedHour = totalTime! / 60
                selectedMinute = totalTime! % 60
            }
        }
    }

    private func updateTotalTimeInMinutes() {
        totalTime = (selectedHour * 60) + selectedMinute
    }
}
