//
//  CreateEditStepView.swift
//  Gourmetus
//
//  Created by Eduardo Dalencon on 26/10/23.
//

import SwiftUI
import PhotosUI

struct CreateEditStepView: View, CreateEditStepDelegate {
    
    @Binding var editingStep: Step?
    @Binding var recipe: Recipe
    
    var ingredients: [Ingredient] {
        recipe.ingredients
    }
    
    @StateObject private var imageViewModel = PhotoPickerViewModel()
    @StateObject var stepViewModel =  CreateEditStepViewModel()
    
    @ObservedObject var recipeViewModel:  CreateEditRecipeViewModel
    
    @Binding var showSheet: Bool
    @State private var selection: String?
    @State var selectedIngediant: Ingredient = Ingredient(id: UUID(), name: "", quantity: "", unit: .Kg)
    
    @Environment(\.dismiss) private var dismiss
    //@Binding var recipe: Recipe
    var imageData: UIImage? {
        self.imageViewModel.selectedImage
    }
    
    var menuKeys: [String] {
        Array($stepViewModel.menu.wrappedValue.keys).sorted()
    }
    
    var isEmptyState: Bool {
        $stepViewModel.menu["Image"].wrappedValue == false && $stepViewModel.menu["Text"].wrappedValue == false && stepViewModel.ingredientsAdded == [] && $stepViewModel.menu["Tip"].wrappedValue == false && $stepViewModel.menu["Timer"].wrappedValue == false
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing:default_spacing) {
                Section {
                    HStack{
                        Text("Title")
                        TextField("Enter title", text: $stepViewModel.title)
                            .foregroundColor(Color.color_card_container_stroke)
                    }
                    .padding()
                }
                .background(Color.white)
//                Button {
//                    // TODO: Falta a binding de recipe no lugar da recipe view model.
////                    stepViewModel.save(recipeViewModel.)
//                } label: {
//                    Text("salva caralho")
//                }
            .cornerRadius(half_spacing)
            .padding(.leading,default_spacing)
            .padding(.trailing,default_spacing)
            
            ScrollView {
                if isEmptyState {
                    HStack {
                        Text("Add a component into the editor to build your step.")
                            .padding()
                            .foregroundColor(Color.color_text_container_primary)
                            .font(.subheadline)
                        Spacer()
                    }
                        //.fixedSize(horizontal: true, vertical: true)
                } else {
                    if($stepViewModel.menu["Image"].wrappedValue ?? false) {
                        VStack {
                            PhotosPicker(selection: $imageViewModel.imageSelecion,
                                         matching: .any(of: [.images, .not(.screenshots)])) {
                                if let image = imageViewModel.selectedImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 360, height: 100)
                                        .foregroundColor(.red)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                        .padding(0)
                                        .onAppear {
                                            print(imageViewModel.selectedImage)
                                        }
                                    
                                } else {
                                    Image(systemName: "photo")
                                        .font(
                                            Font.custom("SF Pro", size: 50)
                                                .weight(.medium)
                                        )
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color.color_text_container_primary)
                                        .frame(width: 360, height: 100)
                                        .background(Color.color_background_container_primary)
                                        .cornerRadius(half_spacing)
                                }
                            }
                            .background(Color.color_card_container_stroke)
                        }
                        .padding(.horizontal,default_spacing)
                        .padding(.top,half_spacing)
                        .background(Color.color_card_container_stroke)
                    }
                    
                    
                    if ($stepViewModel.menu["Text"].wrappedValue ?? false) {
                        Section {
                            TextField("Enter text", text: $stepViewModel.texto,axis: .vertical)
                                .textFieldStyle(PlainTextFieldStyle())
                                .lineLimit(4)
                                .foregroundColor(Color.color_text_container_primary)
                                .background(Color.color_background_container_primary)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding(.horizontal,default_spacing)
                                .padding(.vertical,half_spacing)
                        }
                        .background(Color.color_background_container_primary)
                        .cornerRadius(half_spacing)
                        .padding(.horizontal,default_spacing)
                        .padding(.top,half_spacing)
                    }
                    
                    if (!stepViewModel.ingredientsAdded.isEmpty) {
                        VStack(alignment: .leading) {
                            Text("Ingredients")
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .foregroundStyle(.gray)
                                .padding(.bottom,-default_spacing)
                                .padding(.top,half_spacing)
                                .padding(.leading,default_spacing)
                            ResizableTagGroup(visualContent: stepViewModel.ingredientsAdded.map({ ingredient in
                                Button(action: {
                                    stepViewModel.toggleIngredient(ingredient: ingredient)
                                }, label: {
                                    Text(ingredient.name)
                                        .padding(half_spacing)
                                        .foregroundColor(.white)
                                        .background(Color.color_text_container_highlight, in: .rect(cornerRadius: hard_radius))
                                })
                            }))
                            .padding()
                        }
                        .background(Color.color_background_container_primary)
                        .cornerRadius(half_spacing)
                        .padding(.horizontal,default_spacing)
                        .padding(.top,half_spacing)
                    }
                    
                    if ($stepViewModel.menu["Tip"].wrappedValue ?? false) {
                        Section {
                            TextField("Enter tip", text: $stepViewModel.tip,axis: .vertical)
                                .textFieldStyle(PlainTextFieldStyle())
                                .lineLimit(4)
                                .foregroundColor(Color.color_text_container_primary)
                                .background(Color.color_background_container_primary)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding(.horizontal,default_spacing)
                                .padding(.vertical,half_spacing)
                        }
                        .background(Color.color_background_container_primary)
                        .cornerRadius(half_spacing)
                        .padding(.horizontal,default_spacing)
                        .padding(.top,half_spacing)
                    }
                    
                    if ($stepViewModel.menu["Timer"].wrappedValue ?? false) {
                        VStack(alignment: .leading) {
                            TimePicker(totalTime: $stepViewModel.totalTime)
                                .cornerRadius(half_spacing)
                        }
                        .background(Color.color_background_container_primary)
                        .cornerRadius(half_spacing)
                        .padding(.horizontal,default_spacing)
                        .padding(.top,half_spacing)
                    }
                }
            }
            .background(Color.color_card_container_stroke)
            
            
            VStack(alignment: .leading) {
                List{
                    Section{
                        ForEach(menuKeys, id: \.self) { key in
                            HStack {
                                Text(LocalizedStringKey(key))
                                
                                Spacer()
                                
                                Button(action: {
                                    stepViewModel.menu[key] = !(stepViewModel.menu[key] ?? true)
                                }, label: {
                                    Text(stepViewModel.menu[key] == false ? "Add" : "Remove")
                                        .foregroundStyle(Color.color_button_container_primary)
                                })
                                
                            }
                        }
                        
                        HStack {
                            Text("Ingredient")
                            
                            Spacer()
                            
                            Menu("Add"){
                                ForEach(ingredients.filter({ !stepViewModel.ingredientsAdded.contains($0) })){ ingredient in
                                    Button(ingredient.name) {
                                        stepViewModel.toggleIngredient(ingredient: ingredient)
                                    }
                                }
                            }
                            .foregroundStyle(Color.color_button_container_primary)
                        }
                    } header: {
                        Text("Components")
                    }
                    
                    
                    
                }
                .scrollDisabled(true)
                .listStyle(.insetGrouped)
                .background(Color.color_background_container_primary)
                .scrollContentBackground(.hidden)
                .frame(height:250)
            }
            
        }
        .listStyle(.insetGrouped)
        .scrollDismissesKeyboard(.immediately)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Edit Recipe")
            .toolbar {
                Button(action: {
                    stepViewModel.save(self.recipe)
                    dismiss()
                }) {
                    Text("Save")
                }
            }
        .background(Color.color_background_container_primary)
        .padding(.top,default_spacing)
        .onAppear(perform: {
            self.stepViewModel.delegate = self
            
            if (editingStep != nil){
                stepViewModel.editField(step: editingStep!)
            } else {
                stepViewModel.texto = ""
                stepViewModel.tip = ""
            }
        })
    }
    
}

#Preview {
    CreateEditStepView(editingStep: .constant(Constants.mockedSteps1[0]), recipe: .constant(Constants.mockedRecipe), recipeViewModel: CreateEditRecipeViewModel(), showSheet: .constant(false))
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
        .cornerRadius(half_spacing)
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
