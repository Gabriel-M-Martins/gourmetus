//
//  RecipeDetailsView.swift
//  Gourmetus
//
//  Created by Thiago Defini on 24/10/23.
//

import SwiftUI

struct RecipeDetailsView: View {
    
    enum Destination {
        case Player
        case Edit
    }
    
    @StateObject var vm: RecipeDetailsViewModel
    
    @EnvironmentObject var cookbook: Cookbook
    @State private var isNextViewActivated: Bool = false
    @State private var destination: Destination = .Player
    
    init(recipe: Recipe) {
        self._vm = StateObject(wrappedValue: RecipeDetailsViewModel(recipe: recipe))
    }
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .center, spacing: default_spacing) {
                    Image.bookFavourites
                        .resizable()
                        .scaledToFill()
                        .frame(height: UIScreen.main.bounds.width/2.5)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: smooth_radius, height: smooth_radius)))
                    
                    
                    
                    VStack(alignment: .subCenter, spacing: half_spacing) {
                        HStack(alignment: .top) {
                            Spacer()
                            
                            HStack {
                                Image.clockFill
                                Text(vm.convertHoursMinutes())
                            }
                            
                            Text("・")
                                .alignmentGuide(.subCenter) { d in d.width/2 }
                            
                            HStack {
                                Text("BY")
                                Image.personCircle
                                Text("YOU")
                            }
                            
                            Spacer()
                        }
                        .foregroundStyle(Color.color_text_container_muted)
                        
                        HStack(alignment: .center) {
                            Spacer()
                            
                            // TODO: foreach de dificuldade || componente de dificuldade
                            HStack {
                                KnifeView(recipe: vm.recipe)
                            }
                            
                            Text("・")
                                .alignmentGuide(.subCenter) { d in d.width/2 }
                            
                            HStack {
                                Image.starFill
                                Text("\(String(format: "%.1f", vm.recipe.rating))")
                            }
                            .foregroundStyle(Color.color_text_review_primary)
                            
                            Spacer()
                        }
                    }
                    .modifier(Span())
                    
                    // TODO: componente de resizable tag collection
                    ScrollView{
                        ResizableTagGroup(visualContent: vm.recipe.tags.map({ tag in
                            TagView(Tag: tag.name) {
                                Text("Nothing to see here yet.")
                                    .modifier(Title())
                                    .foregroundStyle(Color.color_text_container_highlight)
                            }
                        }))
                    }
                    .frame(width: UIScreen.main.bounds.width/1.5)
                    Divider()
                }
                
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
            
            
            if let description = vm.recipe.desc {
                Section {
                    Text(description)
                } header: {
                    Text("Description")
                }
            }
            
            // TODO: Empty state de ingredients
            Section {
                ForEach(vm.recipe.ingredients) { ingredient in
                    HStack {
                        Text(ingredient.name)
                        
                        Spacer()
                        
                        Text("\(ingredient.quantity) \(ingredient.unit.description)")
                            .foregroundStyle(Color.color_text_container_muted)
                    }
                }
            } header: {
                Text("Ingredients")
            }
            
            // TODO: Empty state de steps
            Section {
                ForEach(0..<vm.recipe.steps.count) { idx in
                    HStack {
                        Text(vm.recipe.steps[idx].title)
                            .foregroundStyle(Color.color_text_container_highlight)
                        
                        Spacer()
                        
                        Image.chevronRight
                            .foregroundColor(Color.color_button_container_primary)
                    }
                    .background(
                        // TODO: Ir para o player no passo escolhido
                        
                        NavigationLink(destination: RecipePlayerView(recipe: vm.recipe, step: idx), label: {})
                    )
                }
            } header: {
                Text("Steps")
            }
            
            HStack {
                Spacer()
                
                Button(action: {
                    isNextViewActivated = true
                    self.destination = .Player
                }) {
                    Text("Start")
                        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.075)
                        .foregroundStyle(Color.color_general_fixed_light)
                        .modifier(Header())
                    
                }
                .tint(.color_button_container_primary)
                .buttonStyle(.borderedProminent)
                .overlay(
                    GeometryReader { proxy in
                        Button("") {
                            vm.toggleFavourite()
                        }
                        .buttonStyle(FavoriteButtonStyle(isFavorited: $vm.isFavorite))
                        .position(x: proxy.frame(in: .local).width + half_spacing + UIScreen.main.bounds.width * 0.045, y: proxy.frame(in: .local).midY)
                    }
                )
                
                Spacer()
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
        }
        .toolbarRole(.editor)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    ForEach(RecipeDetailsViewModel.MenuOption.allCases, id: \.self) { option in
                        Button(role: option.isDestructive ? ButtonRole.destructive : nil) {
                            vm.menuButtonClicked(option)
                        } label: {
                            Text(option.description)
                        }
                    }
                } label: {
                    Image.ellipsisCircle
                        .foregroundStyle(Color.color_button_container_primary)
                }
            }
        })
        .navigationTitle(vm.recipe.name)
        .navigationDestination(isPresented: $isNextViewActivated) {
            switch destination {
            case .Player:
                RecipePlayerView(recipe: self.vm.recipe, step: 0)
            case .Edit:
                CreateEditRecipeView(recipe: self.$vm.recipe.toOptional())
            }
            
        }
        .onAppear {
            self.vm.populateCookbook(cookbook: self.cookbook)
            self.vm.delegate = self
        }
    }
}

#Preview {
    NavigationStack {
        RecipeDetailsView(recipe: Constants.mockedRecipe)
            .environmentObject(Cookbook())
    }
}

extension Binding {
    func toOptional() -> Binding<Value?> {
        return Binding<Value?> {
            self.wrappedValue
        } set: { val in
            self.wrappedValue = val ?? self.wrappedValue
        }
    }
}

extension RecipeDetailsView: RecipeDetailsDelegate {
    
    func editRecipe() {
        self.destination = .Edit
        self.isNextViewActivated = true
    }
}

extension HorizontalAlignment {
    enum SubCenter: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[HorizontalAlignment.center]
        }
    }
    
    static let subCenter = HorizontalAlignment(SubCenter.self)
}
