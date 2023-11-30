import SwiftUI
import PhotosUI

struct CreateEditRecipeView: View {
    
    @StateObject private var imageViewModel = PhotoPickerViewModel()
    @StateObject private var createEditViewModel: CreateEditRecipeViewModel
    
    @State private var isPresentingNewSheet = false
    @State private var isPresentingEditSheet = false
    @State private var isPresentingIngredientSheet = false
    @State private var isTimePickerPresented = false
    
    @EnvironmentObject var envCookbook: Cookbook
    
    init(recipe: Recipe? = nil) {
        _createEditViewModel = .init(wrappedValue: CreateEditRecipeViewModel(recipe: recipe ?? Recipe(), editing: recipe != nil))
    }
    
    @State private var selectedDifficulty: Int = 1
    
    @FocusState private var isFocused: Bool
    
    @State var hourSelection = 0
    @State var minuteSelection = 0
    
    @State private var selectedTime = Date()
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        GeometryReader { geometry in
            List{
                
                Section {
                    HStack{
                        Text("Title")
                            .bold()
                        TextField("Enter title", text: $createEditViewModel.recipeTitle)
                        
                    }
                    
                } header: {
                    Text("title")
                }
                
                
                Section {
                    PhotosPicker(selection: $imageViewModel.imageSelecion,
                                 matching: .any(of: [.images, .not(.screenshots)])) {
                        if let image = imageViewModel.selectedImage {
                            Image(uiImage: image)
                            
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame( width: 330, height: 200)
                                .foregroundColor(.red)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .padding(0)
                            
                        } else {
                            Image(systemName: "placeholdertext.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 330, height: 200)
                                .foregroundColor(.red)
                                .background(Color.blue)
                                .listRowInsets(EdgeInsets())
                        }
                    }
                    
                    
                }header: {
                    Text("image")
                }
                
                
                
                Section {
                    HStack{
                        Text("Duration")
                        Spacer()
                        Text("\(createEditViewModel.hourSelection) hours and \(createEditViewModel.minuteSelection) minutes")
                    }
                    .sheet(isPresented: $isTimePickerPresented) {
                        DurationPickerView(recipeViewModel: createEditViewModel,showSheet: $isTimePickerPresented)
                            .presentationDetents([.fraction(0.3)])
                    }
                    .onTapGesture {
                        isTimePickerPresented.toggle()
                    }
                    
                    VStack {
                        Picker("Difficulty", selection: $createEditViewModel.difficulty) {
                            Text("1").tag(1)
                            Text("2").tag(2)
                            Text("3").tag(3)
                            Text("4").tag(4)
                            Text("5").tag(5)
                        }
                        .pickerStyle(DefaultPickerStyle())
                    }
                    
                    
                }header: {
                    Text("General Information")
                    Divider()
                }
                .padding(0)
                .listStyle(.plain)
                
                Section {
                    TextEditor(text: $createEditViewModel.desc)
                        .frame(height: 100)
                    
                } header: {
                    Text("Description")
                }
                
                
                Section {
                    HStack{
                        Text("Add Ingredient")
                            .foregroundColor(.accentColor)
                        Spacer()
                        Text("+")
                            .foregroundColor(.accentColor)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture{
                        isPresentingIngredientSheet.toggle()
                    }
                    
                } header: {
                    Text("Ingredients")
                }
                
                Section {
                    ForEach(createEditViewModel.ingredients) { ingredient in
                        HStack {
                            Text(ingredient.name)
                            Spacer()
                            Text(ingredient.quantity)
                                .foregroundColor(.secondary)
                            Text(ingredient.unit.rawValue)
                                .foregroundColor(.secondary)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture{
                            createEditViewModel.editingIngredient = ingredient
                            isPresentingIngredientSheet.toggle()
                        }
                    }
                    .onDelete { indexSet in
                        createEditViewModel.ingredients.remove(atOffsets: indexSet)
                    }
                }
                
                
                // TODO: - AQUI
                Section {
                    HStack{
                        Text("Add Steps")
                            .foregroundColor(.accentColor)
                        Spacer()
                        Text("+")
                            .foregroundColor(.accentColor)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture{
                        createEditViewModel.editingStep = Step()
                        isPresentingEditSheet.toggle()
                    }
                } header: {
                    Text("Steps")
                }
                
                Section {
                    ForEach(createEditViewModel.steps) { step in
                        HStack{
                            Text(step.title)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.accentColor)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture{
                            createEditViewModel.editingStep = step
                            isPresentingEditSheet.toggle()
                        }
                    }
                    .onMove(perform: { from, to in
                        createEditViewModel.steps.move(fromOffsets: from, toOffset: to)
                        
                    })
                    .onDelete { indexSet in
                        createEditViewModel.steps.remove(atOffsets: indexSet)
                    }
                }
            }
            .sheet(isPresented: $isPresentingNewSheet) {
                CreateEditStepViewV2(ingredients: createEditViewModel.ingredients, steps: $createEditViewModel.steps)
            }
            .sheet(isPresented: $isPresentingEditSheet) {
                CreateEditStepViewV2(ingredients: createEditViewModel.ingredients, step: createEditViewModel.editingStep, steps: $createEditViewModel.steps)
            }
            .sheet(isPresented: $isPresentingIngredientSheet) {
                ZStack {
                    Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)
                    CreateEditIngredientView(editingIngredient: $createEditViewModel.editingIngredient, recipeViewModel: createEditViewModel, showSheet: $isPresentingIngredientSheet)
                }
                
                .presentationDetents([.fraction(0.3)])
            }
            
            .listStyle(.insetGrouped)
            .scrollDismissesKeyboard(.immediately)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(createEditViewModel.editing ? "Edit Recipe" : "Add Recipe")
            .toolbar {
                Button(action: {
                    if let image = imageViewModel.selectedImage {
                        self.createEditViewModel.image = image
                    }
                    createEditViewModel.populateCookbook(cookbook: envCookbook)
                    createEditViewModel.save()
                    isPresentingNewSheet = false
                    dismiss()
                }) {
                    Text("Save")
                }
                .disabled(createEditViewModel.recipeTitle.isEmpty || (createEditViewModel.hourSelection == 0 && createEditViewModel.minuteSelection == 0))
            }
        }
        .onAppear {
            createEditViewModel.populateCookbook(cookbook: self.envCookbook)
            
            if let imageData = createEditViewModel.recipe.imageData {
                imageViewModel.selectedImage = UIImage(data: imageData)
            } else {
                imageViewModel.selectedImage = UIImage(named: "banner-placeholder")
            }
            
            self.createEditViewModel.populateCookbook(cookbook: self.envCookbook)
        }
    }
    
}


#Preview {
    NavigationStack {
        CreateEditRecipeView()
    }
    .environmentObject(Constants.mockedCookbook)
}

