//
//  CreateEditStepView.swift
//  Gourmetus
//
//  Created by Eduardo Dalencon on 26/10/23.
//

import SwiftUI
import PhotosUI


struct CreateEditStepView: View, CreateEditStepDelegate {
    //var editingStep: Step = Step()
    
    
    //    @Binding var editingStep: Step
    //    @Binding var recipe: Recipe
    //    var ingredients: [Ingredient] {
    //        recipe.ingredients
    //    }
    //    @StateObject private var imageViewModel = PhotoPickerViewModel()
    //    @StateObject var stepViewModel =  CreateEditStepViewModel()
    //
    //    @ObservedObject var recipeViewModel:  CreateEditRecipeViewModel
    //    var mode: Mode
    //
    //    enum Mode {
    //        case Creating
    //        case Editing(Binding<Step>)
    //    }
    //    @State var editingStep: Step = Step()
    //    @State private var selection: String?
    //    @State var selectedIngediant: Ingredient = Ingredient(id: UUID(), name: "", quantity: "", unit: .Kg)
    //    @Environment(\.dismiss) private var dismiss
    //    @Binding var recipe: Recipe
    
    @Binding var recipe: Recipe
    @ObservedObject var editingStep: Step = Step()
    
    @StateObject var stepViewModel = CreateEditStepViewModel()
    @StateObject private var imageViewModel = PhotoPickerViewModel()
    
    @Environment(\.dismiss) private var dismiss
    
    var imageSelected: UIImage? {
        imageViewModel.selectedImage
    }
    
    var mode: Mode
    
    enum Mode {
        case Creating
        case Editing(stepEdit:Binding<Step>)
    }
    
    var ingredients: [Ingredient] {
        recipe.ingredients
    }
    
    
    var bindingText: Binding<String> {
        return Binding {
            editingStep.texto != nil ? editingStep.texto! : ""
        } set: { str in
            editingStep.texto = str
        }
    }
    
    var bindingTip: Binding<String> {
        return Binding {
            editingStep.tip != nil ? editingStep.tip! : ""
        } set: { str in
            editingStep.tip = str
        }
    }
    
    
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing:default_spacing) {
                HStack{
                    Text("Title")
                    TextField("Step title", text: $editingStep.title)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(half_spacing)
                .padding(.leading,default_spacing)
                .padding(.trailing,default_spacing)
                
                ScrollView{
                    if stepViewModel.isEmptyState {
                        HStack {
                            Text("Add a component into the editor to build your step.")
                                .padding()
                                .foregroundColor(Color.color_text_container_primary)
                                .font(.subheadline)
                            Spacer()
                        }
                    }
                    if(stepViewModel.vector["Image"] == true) {
                        VStack {
                            PhotosPicker(selection: $imageViewModel.imageSelecion,
                                         matching: .any(of: [.images, .not(.screenshots)])) {
                                //                                if let image = imageViewModel.selectedImage {
                                //                                    Image(uiImage: image)
                                //                                        .resizable()
                                //                                        .aspectRatio(contentMode: .fill)
                                //                                        .frame(width: 360, height: 100)
                                //                                        .foregroundColor(.red)
                                //                                        .background(Color.blue)
                                //                                        .cornerRadius(10)
                                //                                        .padding(0)
                                //                                        .onAppear {
                                //                                            editingStep.imageData = image.pngData()
                                //                                        }
                                //                                } else {
                                //                                    if(stepViewModel.image != nil){
                                //                                        Image(uiImage:UIImage(data: stepViewModel.image!)!)
                                //                                            .resizable()
                                //                                            .aspectRatio(contentMode: .fill)
                                //                                            .frame(width: 360, height: 100)
                                //                                            .foregroundColor(.red)
                                //                                            .background(Color.blue)
                                //                                            .cornerRadius(half_spacing)
                                //                                            .padding(0)
                                //                                            .onAppear {
                                //                                            }
                                //                                    } else {
                                Image(uiImage: stepViewModel.image)
                                    .resizable()
                                    .scaledToFill()
                                    .font(
                                        Font.custom("SF Pro", size: 50)
                                            .weight(.medium)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.color_text_container_primary)
                                    .frame(width: 360, height: 100)
                                    .background(Color.color_background_container_primary)
                                    .cornerRadius(half_spacing)
                                //}
                                //}
                            }
                                         .background(Color.color_card_container_stroke)
                        }
                        .padding(.horizontal,default_spacing)
                        .padding(.top,half_spacing)
                        .background(Color.color_card_container_stroke)
                    }
                    
                    if (stepViewModel.vector["Text"] == true) {
                        Section {
                            TextField("Enter text", text: bindingText, axis: .vertical)
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
                    
                    if(stepViewModel.vector["Tip"] == true){
                        Section {
                            TextField("Enter text", text: bindingTip, axis: .vertical)
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
                }
                .background(Color.color_card_container_stroke)
                .padding(.top,default_spacing)
                
                List {
                    Section {
                        ForEach(Array(stepViewModel.vector.keys).sorted(by: {$0 < $1}), id: \.self){ vec in
                            HStack{
                                Text(vec)
                                Spacer()
                                Button {
                                    stepViewModel.vector[vec]?.toggle()
                                    
                                } label: {
                                    Text(stepViewModel.vector[vec] == false ? "Add" : "Remove")
                                        .foregroundStyle(Color.color_button_container_primary)
                                }
                            }
                            
                        }
                        HStack{
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
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Edit Recipe")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        stepViewModel.save()
                        dismiss()
                    }) {
                        Text("Save")
                            .bold()
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Close")
                    }.tint(.black)
                }
            }
            .background(Color.color_background_container_primary)
            .padding(.top,default_spacing)
            .background(Color.color_background_container_primary)
            .onAppear{
                self.stepViewModel.delegate = self
                
                switch(mode){
                case .Creating:
                    editingStep = Step()
                    break
                case let .Editing(stepEdit):
                    editingStep = stepEdit
                    break
                }
                
                stepViewModel.setVisibility()
            }
        }
    }
    
    //        NavigationStack {
    //            VStack(alignment: .leading, spacing:default_spacing) {
    //                Section {
    //                    HStack{
    //                        Text("Title")
    //                        TextField("Step title", text: titleField)
    //                            //.foregroundColor(Color.color_card_container_stroke)
    //                    }
    //                    .padding()
    //                }
    //                .background(Color.white)
    //                .cornerRadius(half_spacing)
    //                .padding(.leading,default_spacing)
    //                .padding(.trailing,default_spacing)
    //
    //                ScrollView {
    //                    if isEmptyState {
    //                        HStack {
    //                            Text("Add a component into the editor to build your step.")
    //                                .padding()
    //                                .foregroundColor(Color.color_text_container_primary)
    //                                .font(.subheadline)
    //                            Spacer()
    //                        }
    //                        //.fixedSize(horizontal: true, vertical: true)
    //                    } else {
    //                        if($stepViewModel.menu["Image"].wrappedValue ?? false) {
    //                            VStack {
    //                                PhotosPicker(selection: $imageViewModel.imageSelecion,
    //                                             matching: .any(of: [.images, .not(.screenshots)])) {
    //                                    if let image = imageViewModel.selectedImage {
    //                                        Image(uiImage: image)
    //                                            .resizable()
    //                                            .aspectRatio(contentMode: .fill)
    //                                            .frame(width: 360, height: 100)
    //                                            .foregroundColor(.red)
    //                                            .background(Color.blue)
    //                                            .cornerRadius(10)
    //                                            .padding(0)
    //                                            .onAppear {
    //                                                editingStep.imageData = image.pngData()
    //                                            }
    //                                    } else {
    //                                        if(stepViewModel.image != nil){
    //                                            Image(uiImage:UIImage(data: stepViewModel.image!)!)
    //                                                .resizable()
    //                                                .aspectRatio(contentMode: .fill)
    //                                                .frame(width: 360, height: 100)
    //                                                .foregroundColor(.red)
    //                                                .background(Color.blue)
    //                                                .cornerRadius(10)
    //                                                .padding(0)
    //                                        } else {
    //                                            Image(systemName: "photo")
    //                                                .font(
    //                                                    Font.custom("SF Pro", size: 50)
    //                                                        .weight(.medium)
    //                                                )
    //                                                .multilineTextAlignment(.center)
    //                                                .foregroundColor(Color.color_text_container_primary)
    //                                                .frame(width: 360, height: 100)
    //                                                .background(Color.color_background_container_primary)
    //                                                .cornerRadius(half_spacing)
    //                                        }
    //                                    }
    //                                }
    //                                             .background(Color.color_card_container_stroke)
    //                            }
    //                            .padding(.horizontal,default_spacing)
    //                            .padding(.top,half_spacing)
    //                            .background(Color.color_card_container_stroke)
    //                        }
    //
    //
    //                        if ($stepViewModel.menu["Text"].wrappedValue ?? false) {
    //                            Section {
    //                                TextField("Enter text", text: textoField, axis: .vertical)
    //                                    .textFieldStyle(PlainTextFieldStyle())
    //                                    .lineLimit(4)
    //                                    .foregroundColor(Color.color_text_container_primary)
    //                                    .background(Color.color_background_container_primary)
    //                                    .frame(minWidth: 0, maxWidth: .infinity)
    //                                    .padding(.horizontal,default_spacing)
    //                                    .padding(.vertical,half_spacing)
    //                            }
    //                            .background(Color.color_background_container_primary)
    //                            .cornerRadius(half_spacing)
    //                            .padding(.horizontal,default_spacing)
    //                            .padding(.top,half_spacing)
    //                        }
    //
    //                        if (!stepViewModel.ingredientsAdded.isEmpty) {
    //                            VStack(alignment: .leading) {
    //                                Text("Ingredients")
    //                                    .textFieldStyle(RoundedBorderTextFieldStyle())
    //                                    .foregroundStyle(.gray)
    //                                    .padding(.bottom,-default_spacing)
    //                                    .padding(.top,half_spacing)
    //                                    .padding(.leading,default_spacing)
    //                                ResizableTagGroup(visualContent: stepViewModel.ingredientsAdded.map({ ingredient in
    //                                    Button(action: {
    //                                        stepViewModel.toggleIngredient(ingredient: ingredient)
    //                                    }, label: {
    //                                        Text(ingredient.name)
    //                                            .padding(half_spacing)
    //                                            .foregroundColor(.white)
    //                                            .background(Color.color_text_container_highlight, in: .rect(cornerRadius: hard_radius))
    //                                    })
    //                                }))
    //                                .padding()
    //                            }
    //                            .background(Color.color_background_container_primary)
    //                            .cornerRadius(half_spacing)
    //                            .padding(.horizontal,default_spacing)
    //                            .padding(.top,half_spacing)
    //                        }
    //
    //                        if ($stepViewModel.menu["Tip"].wrappedValue ?? false) {
    //                            Section {
    //                                TextField("Enter tip", text: tipField, axis: .vertical)
    //                                    .textFieldStyle(PlainTextFieldStyle())
    //                                    .lineLimit(4)
    //                                    .foregroundColor(Color.color_text_container_primary)
    //                                    .background(Color.color_background_container_primary)
    //                                    .frame(minWidth: 0, maxWidth: .infinity)
    //                                    .padding(.horizontal,default_spacing)
    //                                    .padding(.vertical,half_spacing)
    //                            }
    //                            .background(Color.color_background_container_primary)
    //                            .cornerRadius(half_spacing)
    //                            .padding(.horizontal,default_spacing)
    //                            .padding(.top,half_spacing)
    //                        }
    //
    //                        if ($stepViewModel.menu["Timer"].wrappedValue ?? false) {
    //                            VStack(alignment: .leading) {
    //                                TimePicker(totalTime: timerField.toOptional())
    //                                    .cornerRadius(half_spacing)
    //                            }
    //                            .background(Color.color_background_container_primary)
    //                            .cornerRadius(half_spacing)
    //                            .padding(.horizontal,default_spacing)
    //                            .padding(.top,half_spacing)
    //                        }
    //                    }
    //                }
    //                .background(Color.color_card_container_stroke)
    //
    //
    //                VStack(alignment: .leading) {
    //                    List{
    //                        Section{
    //                            ForEach(menuKeys, id: \.self) { key in
    //                                HStack {
    //                                    Text(LocalizedStringKey(key))
    //
    //                                    Spacer()
    //
    //                                    Button(action: {
    //                                        stepViewModel.menu[key] = !(stepViewModel.menu[key] ?? true)
    //                                    }, label: {
    //                                        Text(stepViewModel.menu[key] == false ? "Add" : "Remove")
    //                                            .foregroundStyle(Color.color_button_container_primary)
    //                                    })
    //
    //                                }
    //                            }
    //
    //                            HStack {
    //                                Text("Ingredient")
    //
    //                                Spacer()
    //
    //                                Menu("Add"){
    //                                    ForEach(ingredients.filter({ !stepViewModel.ingredientsAdded.contains($0) })){ ingredient in
    //                                        Button(ingredient.name) {
    //                                            stepViewModel.toggleIngredient(ingredient: ingredient)
    //                                        }
    //                                    }
    //                                }
    //                                .foregroundStyle(Color.color_button_container_primary)
    //                            }
    //                        } header: {
    //                            Text("Components")
    //                        }
    //                    }
    //                    .scrollDisabled(true)
    //                    .listStyle(.insetGrouped)
    //                    .background(Color.color_background_container_primary)
    //                    .scrollContentBackground(.hidden)
    //                    .frame(height:250)
    //                }
    //
    //            }
    //            .navigationBarTitleDisplayMode(.inline)
    //            .navigationTitle("Edit Recipe")
    //            .toolbar {
    //                ToolbarItem(placement: .topBarTrailing) {
    //                    Button(action: {
    //                        stepViewModel.save()
    //                        dismiss()
    //                    }) {
    //                        Text("Save")
    //                            .bold()
    //                    }
    //                }
    //
    //                ToolbarItem(placement: .topBarLeading) {
    //                    Button(action: {
    //                        dismiss()
    //                    }) {
    //                        Text("Close")
    //                    }.tint(.black)
    //                }
    //            }
    //            .background(Color.color_background_container_primary)
    //            .padding(.top,default_spacing)
    //            .onAppear {
    //                self.stepViewModel.delegate = self
    //                self.stepViewModel.setVisibility()
    //                print(self.stepViewModel.menu)
    //            }
    //        }
    //    }
    
}

#Preview {
    CreateEditStepView(recipe: .constant(Constants.mockedRecipe1),mode: .Editing(stepEdit: .constant(Constants.mockedRecipe1.steps[0])))
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
