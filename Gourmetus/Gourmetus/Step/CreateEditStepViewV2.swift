//
//  CreateEditStepViewV2.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 29/11/23.
//

import SwiftUI
import PhotosUI

final class CreateEditStepViewModelV2: ObservableObject {
    enum Component: String, Hashable {
        case imagePicker = "Image"
        case tip = "Tip"
        case timer = "Timer"
        case ingredients = "Ingredients"
        case description = "Description"
    }
    
    struct OrderedComponent: Hashable {
        func hash(into hasher: inout Hasher) {
            hasher.combine(component)
        }
        
        public static func ==(lhs: OrderedComponent, rhs: OrderedComponent) -> Bool {
            lhs.component == rhs.component
        }
        
        let component: Component
        let order: Int
        
        static let imagePicker: OrderedComponent = OrderedComponent(component: .imagePicker, order: 0)
        static let description: OrderedComponent = OrderedComponent(component: .description, order: 1)
        static let tip: OrderedComponent = OrderedComponent(component: .tip, order: 2)
        static let ingredients: OrderedComponent = OrderedComponent(component: .ingredients, order: 3)
        static let timer: OrderedComponent = OrderedComponent(component: .timer, order: 4)
        
        static let availableComponents: [OrderedComponent] = [
            .imagePicker,
            .description,
            .tip,
            .ingredients,
            .timer
        ]
    }
    
    @Published var title: String = ""
    @Published var tip: String = ""
    @Published var description: String = ""
    
    @Published var timerMinutes: Int = 0
    @Published var timerSeconds: Int = 0
    
    @Published var image: UIImage? = nil
    
    @Published var chosenComponents: Set<OrderedComponent> = []
    var orderedComponents: [CreateEditStepViewModelV2.OrderedComponent] {
        Array(chosenComponents).sorted(by: {$0.order < $1.order})
    }
    
    @Published var chosenIngredients: [Ingredient] = []
    var availableIngredients: [Ingredient] {
        recipe.ingredients.filter( { !chosenIngredients.contains($0) } )
    }
    
    @ObservedObject var recipe: Recipe
    @ObservedObject var step: Step
    @ObservedObject var photosViewModel: PhotoPickerViewModel
    
    init(recipe: Recipe, step: Step? = nil) {
        self.recipe = recipe
        self.step = step ?? Step()
        self._photosViewModel = .init(wrappedValue: PhotoPickerViewModel())
        self.photosViewModel.completionBlock = { [weak self] img in
            self?.image = img
            self?.chosenComponents.insert(.imagePicker)
        }
        
        self.title = self.step.title
        
        if let description = self.step.texto {
            self.description = description
            chosenComponents.insert(.description)
        }
        
        if let tip = self.step.tip {
            self.tip = tip
            chosenComponents.insert(.tip)
        }
        
        chosenIngredients.append(contentsOf: self.step.ingredients)
        if !chosenIngredients.isEmpty {
            chosenComponents.insert(.ingredients)
        }
        
        if let timer = self.step.timer {
            let (quotient, reminder) = timer.quotientAndRemainder(dividingBy: 60)
            self.timerMinutes = quotient
            self.timerSeconds = reminder
            chosenComponents.insert(.timer)
        }
        
        if let data = self.step.imageData,
           let image = UIImage(data: data) {
            self.image = image
            chosenComponents.insert(.imagePicker)
        }
    }
    
    func toggleIngredient(_ ingredient: Ingredient) {
        if let idx = chosenIngredients.firstIndex(of: ingredient) {
            chosenIngredients.remove(at: idx)
        } else {
            chosenIngredients.append(ingredient)
        }
    }
    
    func save() {
        step.title = title
        
        if chosenComponents.contains(.imagePicker),
           let image = self.image,
           let data = image.pngData() {
            step.imageData = data
        }
        
        if chosenComponents.contains(.description) {
            step.texto = self.description
        }
        
        if chosenComponents.contains(.tip) {
            step.tip = nil
        }
        
        step.ingredients = chosenIngredients
        
        if chosenComponents.contains(.timer) {
            step.timer = nil
        }
        
        if let idx = recipe.steps.firstIndex(where: { $0.id == step.id }) {
            recipe.steps[idx] = step
        } else {
            step.order = recipe.steps.count
            recipe.steps.append(step)
        }
    }
}

enum SheetOption {
    case detail, photoPicker
}

struct CreateEditStepViewV2: View {
    @StateObject private var vm: CreateEditStepViewModelV2
    
    @State private var selectedDetent: PresentationDetent = .fraction(Self.sheetDefaultSize)
    @State private var presentSheet: Bool = true
    
    @Environment(\.dismiss) var dismiss
    
    static private let sheetMininumSize: Double = 0.03
    static private let sheetDefaultSize: Double = 0.3
    
    init(recipe: Recipe, step: Step? = nil) {
        self._vm = .init(wrappedValue: CreateEditStepViewModelV2(recipe: recipe, step: step))
    }
    
    var body: some View {
        List {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .foregroundStyle(Color.color_button_container_primary)
                        .bold()
                }
                
                Spacer()
                
                Button {
                    vm.save()
                    dismiss()
                } label: {
                    Text("Save")
                        .foregroundStyle(Color.color_button_container_primary)
                        .bold()
                }
            }
            .padding(.horizontal, default_spacing)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
            Section {
                HStack {
                    Text("Title")
                    TextField("Step Title", text: $vm.title)
                }
            }
            
            ForEach(vm.orderedComponents, id: \.self) { orderedComponent in
                Section {
                    switch orderedComponent.component {
                    case .description:
                        TextField("Description", text: $vm.description, axis: .vertical)
                            .lineLimit(1...4)
                    case .imagePicker:
                        VStack {
                            if let image = vm.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: UIScreen.main.bounds.width * 0.5)
                                    .cornerRadius(hard_radius)
                            } else {
                                EmptyView()
                            }
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        
                    case .timer:
                        HStack {
                            VStack {
                                Picker(selection: $vm.timerMinutes) {
                                    ForEach(0..<60) { idx in
                                        Text("\(idx)").tag(idx)
                                    }
                                } label: {
                                    EmptyView()
                                }
                                .pickerStyle(.wheel)
                                Text("Minutes")
                            }
                            
                            Text(":")
                                .font(.title)
                            
                            VStack {
                                Picker(selection: $vm.timerSeconds) {
                                    ForEach(0..<60) { idx in
                                        Text("\(idx)").tag(idx)
                                    }
                                } label: {
                                    EmptyView()
                                }
                                .pickerStyle(.wheel)
                                Text("Seconds")
                            }
                        }
                    case .tip:
                        TextField("Tip", text: $vm.tip, axis: .vertical)
                            .lineLimit(1...4)
                    case .ingredients:
                        VStack {
                            HStack {
                                Text("Ingredients")
                                Spacer()
                            }
                            
                            HStack {
                                ChipsStack {
                                    ForEach(vm.chosenIngredients) { tag in
                                        TagView(text: tag.name, selected: .constant(true), color: Color.color_text_container_highlight)
                                            .padding(.trailing, half_spacing)
                                            .padding(.bottom, half_spacing)
                                    }
                                }
                                
                                Spacer()
                            }
                        }
                    }
                }
            }
            .onDelete(perform: { indexSet in
                withAnimation {
                    for i in indexSet {
                        let orderedComponent = vm.orderedComponents[i]
                        
                        if orderedComponent.component == .ingredients {
                            vm.chosenIngredients = []
                        }
                        
                        vm.chosenComponents.remove(orderedComponent)
                    }
                }
            })
        }
        .scrollDismissesKeyboard(.immediately)
        .listSectionSpacing(half_spacing)
        .sheet(isPresented: $presentSheet, content: {
            NavigationStack {
                List {
                    Section {
                        ForEach(CreateEditStepViewModelV2.OrderedComponent.availableComponents, id: \.self) { orderedComponent in
                            switch orderedComponent.component {
                            case .ingredients:
                                HStack {
                                    Text(orderedComponent.component.rawValue)
                                    
                                    Spacer()
                                    
                                    Menu {
                                        ForEach(vm.availableIngredients) { ingredient in
                                            Button(ingredient.name) {
                                                withAnimation {
                                                    if vm.chosenIngredients.isEmpty {
                                                        vm.chosenComponents.insert(orderedComponent)
                                                    }
                                                    
                                                    vm.toggleIngredient(ingredient)
                                                }
                                            }
                                        }
                                    } label: {
                                        Text("Add")
                                            .foregroundStyle(vm.availableIngredients.isEmpty ? Color.color_text_container_muted : Color.color_button_container_primary)
                                            .animation(.easeInOut, value: vm.availableIngredients.isEmpty)
                                    }
                                    
                                }
                                
                            case .imagePicker:
                                HStack {
                                    Text(orderedComponent.component.rawValue)
                                    
                                    Spacer()
                                    
                                    PhotosPicker(selection: $vm.photosViewModel.imageSelecion,
                                                 matching: .any(of: [.images, .not(.screenshots)])) {
                                        if vm.chosenComponents.contains(orderedComponent) {
                                            Text("Change")
                                        } else {
                                            Text("Add")
                                        }
                                    }
                                }
                                
                            default:
                                HStack {
                                    Text(orderedComponent.component.rawValue)
                                    
                                    Spacer()
                                    
                                    Button(
                                        vm.chosenComponents.contains(orderedComponent) ? "Remove" : "Add",
                                        role: vm.chosenComponents.contains(orderedComponent) ? .destructive : .cancel
                                    ) {
                                        withAnimation {
                                            if vm.chosenComponents.contains(orderedComponent) {
                                                vm.chosenComponents.remove(orderedComponent)
                                            } else {
                                                vm.chosenComponents.insert(orderedComponent)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } header: {
                        Text("Components")
                    }
                    
                }
            }
            .opacity(selectedDetent == .fraction(Self.sheetDefaultSize) ? 1 : 0)
            .animation(.easeInOut, value: selectedDetent)
            .interactiveDismissDisabled()
            .presentationDetents([.fraction(Self.sheetDefaultSize), .fraction(Self.sheetMininumSize)], selection: $selectedDetent)
            .presentationDragIndicator(.visible)
            .presentationBackgroundInteraction(.enabled)
        })
//        .navigationTitle("Create Step")
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .confirmationAction) {
//                Button {
//                    vm.save()
//                    dismiss()
//                } label: {
//                    Text("Save")
//                }
//            }
//        }
        
    }
}

#Preview {
    NavigationStack {
        CreateEditStepViewV2(recipe: Constants.mockedRecipe, step: Constants.mockedRecipe.steps[0])
    }
    .environmentObject(Constants.mockedCookbook)
    .tint(Color.color_button_container_primary)
}
