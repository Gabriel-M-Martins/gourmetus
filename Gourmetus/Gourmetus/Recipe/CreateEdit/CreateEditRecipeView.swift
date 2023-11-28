import SwiftUI
import PhotosUI

struct CreateEditRecipeView: View {
    
    @StateObject private var imageViewModel = PhotoPickerViewModel()
    @StateObject private var createEditViewModel = CreateEditRecipeViewModel()
    
    @State private var isPresentingNewSheet = false
    @State private var isPresentingEditSheet = false
    @State private var isPresentingIngredientSheet = false
    @State private var isTimePickerPresented = false
    
    @State private var editingStep: Step?
    
    //var recipe: Recipe?
    
    @State private var selectedDifficulty: Int = 1
    
    @FocusState private var isFocused: Bool
    
    @State var hourSelection = 0
    @State var minuteSelection = 0
    
    @EnvironmentObject var cookbook: Cookbook
    
    @State private var selectedTime = Date()
    
    @Environment(\.dismiss) private var dismiss
    
    @State var recipe: Recipe = Recipe()
    
    var mode: Mode
    
    enum Mode {
        case Creating
        case Editing(Binding<Recipe>)
    }
    
    var title: String {
        switch self.mode {
        case .Creating:
            "Add Recipe"
        case .Editing(_):
            "Edit Recipe"
        }
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            List{
                
                Section {
                    HStack{
                        Text("Title")
                        TextField("Enter title", text: $createEditViewModel.recipeTitle)
                        
                    }
                    
                } header: {
                    //Text("title")
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
                        print(isTimePickerPresented)
                        isTimePickerPresented.toggle()
                        print(isTimePickerPresented)
                    }
                    
                    VStack{
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
                    
                }header: {
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
                    .onTapGesture{
                        isPresentingIngredientSheet.toggle()
                    }
                    
                } header: {
                    Text("Ingredients")
                }
                
                
                Section {
                    
                    ForEach(createEditViewModel.ingredients) { ingredient in
                        HStack{
                            Text(ingredient.name)
                            Spacer()
                            Text(ingredient.quantity)
                                .foregroundColor(.secondary)
                            Text(ingredient.unit.description)
                                .foregroundColor(.secondary)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        
                        .onTapGesture{
                            createEditViewModel.editingIngredient = ingredient
                            isPresentingIngredientSheet.toggle()
                        }
                        
                    }
                    .onDelete { indexSet in
                        createEditViewModel.ingredients.remove(atOffsets: indexSet)
                    }
                    
                    
                }
                
                Section {
                    
                    HStack{
                        Text("Add Steps")
                            .foregroundColor(.accentColor)
                        Spacer()
                        Text("+")
                            .foregroundColor(.accentColor)
                    }
                    .onTapGesture{
                        createEditViewModel.editingStep = nil
                        isPresentingEditSheet.toggle()
                    }
                    
                } header: {
                    Text("Steps")
                }
                
                Section {
                    ForEach(createEditViewModel.steps) { step in
                        HStack{
                            Text(step.tip ?? "texto default")
                            Spacer()
                            //                                Text(ingredient.quantity)
                            //                                Text(ingredient.unit.description)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.accentColor)
                        }
                        
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
                CreateEditStepView(recipe: $recipe, mode: .Creating)
            }
            .sheet(isPresented: $isPresentingEditSheet) {
                CreateEditStepView(
                    recipe: $recipe,
                    mode: .Editing(
                        stepEdit: .init(
                            get: {
                                if createEditViewModel.editingStep == nil {
                                    createEditViewModel.editingStep = Step()
                                }
                                
                                return createEditViewModel.editingStep!
                            },
                            set: { newValue in
                                createEditViewModel.editingStep = newValue
                            })
                    ))
            }
            .sheet(isPresented: $isPresentingIngredientSheet) {
                ZStack {
                    Color(.systemGray6).edgesIgnoringSafeArea(.all)
                    CreateEditIngredientView(editingIngredient: $createEditViewModel.editingIngredient,recipeViewModel: createEditViewModel, showSheet: $isPresentingIngredientSheet)
                }
                
                .presentationDetents([.fraction(0.3)])
            }
            
            .listStyle(.insetGrouped)
            .scrollDismissesKeyboard(.immediately)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(self.title)
            .toolbar {
                Button(action: {
                    createEditViewModel.populateCookbook(cookbook: cookbook)
                    createEditViewModel.saveRepo(recipe: recipe)
                    isPresentingNewSheet = false
                    dismiss()
                }) {
                    Text("Save")
                }
            }
        }
        .onAppear(perform: {
            switch self.mode {
            case .Creating:
                break
            case .Editing(let recipe):
                self.recipe = recipe.wrappedValue
            }
            
            createEditViewModel.editRecipe(recipe: self.recipe)
            
            if let imageData = recipe.imageData {
                imageViewModel.selectedImage = UIImage(data: imageData)
            } else {
                imageViewModel.selectedImage = UIImage(named: "banner-placeholder")
            }
            
            self.createEditViewModel.populateCookbook(cookbook: self.cookbook)
            
            //                if (recipe != nil){
            //                    createEditViewModel.editRecipe(recipe: recipe!)
            //                    if let imageData = recipe!.imageData {
            //                       imageViewModel.selectedImage = UIImage(data: imageData)
            //                   } else {
            //                       imageViewModel.selectedImage = UIImage(named: "banner-placeholder")
            //                   }
            //                } else {
            //                    imageViewModel.selectedImage = UIImage(named: "banner-placeholder")
            //                }
        })
    }
    
}

#Preview {
    NavigationStack {
        CreateEditRecipeView(mode: .Creating)
    }
    .environmentObject(Constants.mockedCookbook)
}

