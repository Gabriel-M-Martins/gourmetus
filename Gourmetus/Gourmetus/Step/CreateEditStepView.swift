//
//  CreateEditStepView.swift
//  Gourmetus
//
//  Created by Eduardo Dalencon on 26/10/23.
//

import SwiftUI
import PhotosUI

struct CreateEditStepView: View {
    
    @State var menu = ["Image" : false, "Text": false, "Tip": false, "Timer": false]
    @Binding var editingStep: Step?
    @State var ingredients: [Ingredient] = []
    @StateObject private var imageViewModel = PhotoPickerViewModel()
    @StateObject var stepViewModel =  CreateEditStepViewModel()
    @ObservedObject var recipeViewModel:  CreateEditRecipeViewModel
    @Binding var showSheet: Bool
    @State private var selection: String?
    @State var selectedIngediant: Ingredient = Ingredient(id: UUID(), name: "Farinha", quantity: "0.5", unit: .Kg)
    
    var menuKeys: [String] {
        Array($menu.wrappedValue.keys).sorted()
    }
    
    var isEmptyState: Bool {
        true
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing:16) {
            HStack() {
                Text("Title")
                    .font(.headline)
                TextField("Step Title", text: $stepViewModel.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.leading,16)
            .padding(.trailing,16)
            
            ScrollView{
                if isEmptyState {
                    Text("Add a component into the editor to build your step.")
                        .padding()
                        .fixedSize(horizontal: true, vertical: true)
                } else {
                    if($menu["Image"].wrappedValue ?? false){
                        VStack {
                            Image(uiImage: imageViewModel.selectedImage!)
                                .resizable()
                                .cornerRadius(8)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 360, height: 100)
                                .foregroundColor(.red)
                                .background(Color(.brandWhite))
                            
                            PhotosPicker(selection: $imageViewModel.imageSelecion,
                                         matching: .any(of: [.images, .not(.screenshots)])) {
                                Text("Select Photos")
                            }
                        }
                    }
                    
                    
                    if ($menu["Text"].wrappedValue ?? false) {
                        TextField("Enter text", text: $stepViewModel.texto,axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .lineLimit(4)
                            .background(Color(.brandWhite))
                        
                    }
                    
                    if (stepViewModel.ingredientsAdded != []) {
                        VStack(alignment: .leading) {
                            Text("Ingredients")
                                .foregroundStyle(.gray)
                                .padding(.bottom,-12)
                                .padding(.top,6)
                                .padding(.leading,16)
                            ResizableTagGroup(visualContent: stepViewModel.ingredientsAdded.map({ Text($0.name)
                                    .padding(6)
                                    .foregroundColor(.white)
                                .background(Color(.brandGreen), in: .rect(cornerRadius: 6))})) //[TagView(Tag: "Algo", visualContent: {Text("O")})]
                            .padding()
                        }
                        .background(Color(.brandWhite))
                    }
                    
                    if ($menu["Tip"].wrappedValue ?? false) {
                        TextField("Enter tip", text: $stepViewModel.tip,axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .lineLimit(4)
                            .background(Color(.brandWhite))
                    }
                    
                    if ($menu["Timer"].wrappedValue ?? false) {
                        VStack(alignment: .leading) {
                            TimePicker(totalTime: $stepViewModel.totalTime)
                        }
                    }
                }
            }
            .frame(width: .infinity)
            .background(Color(.brandLightGray))
            
            VStack(alignment: .leading) {
                List{
                    Section{
                        ForEach(menuKeys, id: \.self) { key in
                            HStack {
                                Text(key)
                                
                                Spacer()
                                
                                Button(action: {
                                    menu[key] = !(menu[key] ?? true)
                                }, label: {
                                    Text("Add")
                                        .foregroundStyle(.orange)
                                })
                                
                            }
                        }
                        
                        HStack {
                            Text("Ingredient")
                            
                            Spacer()
                            
                            Menu("Add"){
                                ForEach(ingredients){ ingredient in
                                    Button(ingredient.name) {
                                        stepViewModel.addIngredient(ingredient: ingredient)
                                    }
                                }
                            }
                            .foregroundStyle(.orange)
                        }
                    } header: {
                        Text("Components")
                    }
                    
                    
                    
                }
                .listStyle(.insetGrouped)
                .background(Color(.brandWhite))
                .scrollContentBackground(.hidden)
                .frame(height:250)
            }
            
        }
        .background(Color(.brandWhite))
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
    CreateEditStepView(editingStep: .constant(Constants.mockedSteps[0]),ingredients: [Ingredient(id: UUID(), name: "Farinha", quantity: "0.5", unit: .Kg),
                                                                                      Ingredient(id: UUID(), name: "Ovo", quantity: "3", unit: .L)], recipeViewModel: CreateEditRecipeViewModel(), showSheet: .constant(false))
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
