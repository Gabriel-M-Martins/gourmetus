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
    }

    var title: Binding<String> {
        Binding {
            self.step.title
        } set: { newValue in
            self.step.title = newValue
        }
    }
    
    var tip: Binding<String> {
        Binding {
            self.step.tip ?? ""
        } set: { newValue in
            self.step.tip = newValue
        }
    }
    
    @Published var timerMinutes: Int = 0
    @Published var timerSeconds: Int = 0
    
    @Published var image: UIImage? = nil
    
    @Published var chosenComponents: Set<OrderedComponent> = []
    var orderedComponents: [CreateEditStepViewModelV2.OrderedComponent] {
        Array(chosenComponents).sorted(by: {$0.order < $1.order})
    }
    
    static let availableComponents: [OrderedComponent] = [
        OrderedComponent(component: .imagePicker, order: 0),
        OrderedComponent(component: .tip, order: 1),
        OrderedComponent(component: .ingredients, order: 2),
        OrderedComponent(component: .timer, order: 3)
    ]
    
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
            self?.chosenComponents.insert(Self.availableComponents[0])
        }
        
        if self.step.tip != nil {
            chosenComponents.insert(Self.availableComponents[1])
        }
        
        chosenIngredients.append(contentsOf: self.step.ingredients)
        if !chosenIngredients.isEmpty {
            chosenComponents.insert(Self.availableComponents[2])
        }
        
        if let timer = self.step.timer {
            let (quotient, reminder) = timer.quotientAndRemainder(dividingBy: 60)
            self.timerMinutes = quotient
            self.timerSeconds = reminder
            chosenComponents.insert(Self.availableComponents[3])
        }
        
        if let data = self.step.imageData,
           let image = UIImage(data: data) {
            self.image = image
            chosenComponents.insert(Self.availableComponents[0])
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
        if chosenComponents.contains(Self.availableComponents[0]),
           let image = self.image,
           let data = image.pngData() {
            step.imageData = data
        }
        
        if chosenComponents.contains(Self.availableComponents[1]) {
            step.tip = nil
        }
        
        step.ingredients = chosenIngredients
        
        if chosenComponents.contains(Self.availableComponents[3]) {
            step.timer = nil
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
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("Title")
                        TextField("Step Title", text: vm.title)
                    }
                }
                
                ForEach(vm.orderedComponents, id: \.self) { orderedComponent in
                    Section {
                        switch orderedComponent.component {
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
                            TextField("Tip", text: vm.tip, axis: .vertical)
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
        }
        .listSectionSpacing(half_spacing)
        .sheet(isPresented: $presentSheet, content: {
            NavigationStack {
                List {
                    Section {
                        ForEach(CreateEditStepViewModelV2.availableComponents, id: \.self) { orderedComponent in
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
        .interactiveDismissDisabled(false)
        .navigationTitle("Create Step")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    vm.save()
                    dismiss()
                } label: {
                    Text("Save")
                }
            }
        }
        
    }
}

#Preview {
    NavigationStack {
        CreateEditStepViewV2(recipe: Constants.mockedRecipe, step: Constants.mockedRecipe.steps[0])
    }
    .environmentObject(Constants.mockedCookbook)
    .tint(Color.color_button_container_primary)
}
