import SwiftUI
import PhotosUI

struct CreateEditRecipeView: View {
    
    @StateObject private var imageViewModel = PhotoPickerViewModel()
    @StateObject private var createEditViewModel = CreateEditRecipeViewModel()
    
    @State private var isPresentingNewSheet = false
    @State private var isPresentingEditSheet = false
    
    @State private var editingStep: StepModel?
    
    @Binding var recipe: RecipeModel?
    
    @State private var selectedDifficulty: Int = 1
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView{
                    VStack(alignment: .leading, spacing: 30) {
                        VStack(alignment: .leading) {
                            Text("Title")
                                .font(.headline)
                            TextField("Enter title", text: $createEditViewModel.recipeTitle)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }

                        if let image = imageViewModel.selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 300, height: 200)
                                .foregroundColor(.red)
                                .background(Color.blue)
                        } else {
                            Image(systemName: "placeholdertext.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 300, height: 200)
                                .foregroundColor(.red)
                                .background(Color.blue)
                        }
                        
                        
                        
                        PhotosPicker(selection: $imageViewModel.imageSelecion,
                                     matching: .any(of: [.images, .not(.screenshots)])) {
                            Text("Select Photos")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color(.blue))
                                .cornerRadius(10)
                        }
                        


                        VStack(alignment: .leading) {
                            Text("Description")
                                .font(.headline)
                            TextField("Enter description", text: $createEditViewModel.desc)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        
                        VStack(alignment: .leading) {
                            Text("Difficulty")
                                .font(.headline)
                            HStack {
                                ForEach(1..<6, id: \.self) { difficulty in
                                    Image(systemName: difficulty <= createEditViewModel.difficulty ? "star.fill" : "star")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .onTapGesture {
                                            createEditViewModel.difficulty = difficulty
                                        }
                                }
                            }
                        }
                        

                        // Add Ingredient Button
                        VStack(alignment: .leading,spacing:10){
                            
                            Text("Ingredients")
                                .font(.headline)
                            // Ingredients List
                            if createEditViewModel.ingredients.isEmpty {
                                Text("No ingredients added.")
                            } else {
                                
                                ForEach(createEditViewModel.ingredients) { ingredient in

                                    if(!createEditViewModel.ingredientsBeingEdited.contains(ingredient)){
                                        HStack {
                                            Text(ingredient.name)
                                            Text(ingredient.quantity)
                                            Text(ingredient.unit.description)
                                                
                                                //Botao de editar
                                                Button(action: {
                                                    
                                                    createEditViewModel.toggleIngredientEditing(ingredient: ingredient)
                                                   
                                                }) {
                                                    Image(systemName: "pencil")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 10, height: 10)
                                                        .foregroundColor(.red)
                                                }
    
                                                //Botao de deletar
                                                Button(action: {
                                                    createEditViewModel.deleteIngredient(ingredient: ingredient)
                                                    
                                                }) {
                                                    Image(systemName: "trash")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 10, height: 10)
                                                        .foregroundColor(.red)
                                                }
                                            }
                                        } else {
                                            VStack {
                                                HStack {
                                                    TextField("Ingredient Name", text: $createEditViewModel.ingredientName)
                                                    TextField("Quantity", text: $createEditViewModel.ingredientQuantity)
                                                    
                                                    Picker("Unit", selection: $createEditViewModel.ingredientUnit) {
                                                        ForEach(IngredientUnit.allCases) { unit in
                                                            Text(unit.description)
                                                            }
                                                    }
                                                    .pickerStyle(DefaultPickerStyle())
                                                }
                                                Button(action: {
                                                   
                                                    createEditViewModel.updateIngredient(ingredient: ingredient)
                                                    
                                                   
                                                }) {
                                                    Text("Save Ingredient")
                                                        .foregroundColor(.white)
                                                        .padding(10)
                                                        .background(Color(.blue))
                                                        .cornerRadius(10)
                                                }
                                            }
                                        }
                                    }
                               
                            }
                            
                            if createEditViewModel.isAddingIngredient {
                                VStack {
                                    HStack {
                                        TextField("Ingredient Name", text: $createEditViewModel.ingredientName)
                                        TextField("Quantity", text: $createEditViewModel.ingredientQuantity)
                                        Picker("Unit", selection: $createEditViewModel.ingredientUnit) {
                                            ForEach(IngredientUnit.allCases) { unit in
                                                Text(unit.description)
                                                }
                                        }
                                        .pickerStyle(DefaultPickerStyle())
                                    }
                                    Button(action: {
                                        
                                        createEditViewModel.addIngredient()
                                    }) {
                                        Text("Save Ingredient")
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(Color(.blue))
                                            .cornerRadius(10)
                                    }
                                }
                            } else {
                                Button(action: {
                                    createEditViewModel.isAddingIngredient = true
                                }) {
                                    Text("Add Ingredient")
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(Color(.blue))
                                        .cornerRadius(10)
                                }
                            }
                        }
                        
                        
                        // Add Steps
                        VStack(alignment: .leading,spacing:10){
                            Text("Steps")
                                .font(.headline)
                            // Ingredients List
                            if createEditViewModel.steps.isEmpty {
                                Text("No steps added.")
                            } else {
                                ForEach(createEditViewModel.steps, id: \.self) { step in
                                    HStack{
                                        //Botoes mudanca de ordem
                                        HStack{
                                            Button(action: {
                                                createEditViewModel.swapWithPrevious(step: step)
                                                
                                            }) {
                                                Image(systemName: "arrow.up")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 10, height: 10)
                                                    .foregroundColor(.red)
                                            }
                                            
                                            Button(action: {
                                                createEditViewModel.swapWithNext(step: step)
                                                
                                            }) {
                                                Image(systemName: "arrow.down")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 10, height: 10)
                                                    .foregroundColor(.red)
                                            }
                                        }
                                        
                                        Text(step.texto ?? "vazio")
                                        Text(step.tip ?? "vazio" )
                                        //Text(step.timer ?? "vazio" )
                                        
                                        //Botao de editar
                                        Button(action: {
                                            editingStep = step
                                            print(editingStep)
                                            isPresentingEditSheet.toggle()
     
                                        }) {
                                            Image(systemName: "pencil")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 10, height: 10)
                                                .foregroundColor(.red)
                                        }
                                        
                                        Button(action: {
                                            createEditViewModel.deleteStep(step: step)
                                            
                                        }) {
                                            Image(systemName: "trash")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 10, height: 10)
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                            }
                            
                            Button(action: {
                                isPresentingNewSheet.toggle()
                            }) {
                                Text("Add Step")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color(.blue))
                                    .cornerRadius(10)
                            }
                        }
                        
                    }
                    .frame(width: geometry.size.width * 0.9, alignment: .leading)
                    .sheet(isPresented: $isPresentingNewSheet) {
                        CreateEditStepView(editingStep: $editingStep, recipeViewModel: createEditViewModel, showSheet: $isPresentingNewSheet)
                            }
                    .sheet(isPresented: $isPresentingEditSheet) {
                        CreateEditStepView(editingStep: $editingStep, recipeViewModel: createEditViewModel, showSheet: $isPresentingEditSheet)
                            }
                    .padding()
                    .onAppear(perform: {
                        if (recipe != nil){
                            print("caiu")
                            createEditViewModel.editRecipe(recipe: recipe!)
                            if let imageData = recipe!.imageData {
                               imageViewModel.selectedImage = UIImage(data: imageData)
                           } else {
                               // If recipe has no image data, use the default image
                               imageViewModel.selectedImage = UIImage(named: "DefaultRecipeImage")
                           }
                        } else {
                            imageViewModel.selectedImage = UIImage(named: "DefaultRecipeImage")
                        }
                    })
                }
                }
            }
        }
    
}

struct CreateEditRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        //CreateEditRecipeView()
        Text("oi")
    }
}

