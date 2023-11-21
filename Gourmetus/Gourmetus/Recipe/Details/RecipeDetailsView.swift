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
    
    var recipe: Recipe
    
    @StateObject var vm: RecipeDetailsViewModel = RecipeDetailsViewModel()
    @EnvironmentObject var cookbook: Cookbook
    
    @State private var isNextViewActivated: Bool = false
    @State private var destination: Destination = .Player
    @State private var showAlert = false
    
    @Environment(\.dismiss) private var dismiss
    
    @Injected private var repo: any Repository<Recipe>
    
    var image2: Image {
        if let imgData = recipe.imageData,
           let img = UIImage(data: imgData) {
            Image(uiImage: img)
                .resizable()
            //                .cornerRadius(smooth_radius)
            //                .padding(.top, default_spacing)
            //                .padding(.horizontal, default_spacing)
        } else {
            Image("DefaultRecipeImage")
                .resizable()
            //                .cornerRadius(smooth_radius)
            //                .padding(.top, default_spacing)
            //                .padding(.horizontal, default_spacing)
            //                .frame(height: 145)
        }
    }
    
    var image: Image {
        print (recipe.imageData)
        if let imgData = recipe.imageData,
           let img = UIImage(data: imgData) {
            return Image(uiImage: img)
        } else {
            return Image("DefaultRecipeImage")
        }
        
        //        guard let data = recipe.imageData,
        //              let uiimage = UIImage(data: data) else { return Image.bookFavourites }
        //
        //        return Image(uiImage: uiimage)
    }
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .center, spacing: default_spacing) {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: UIScreen.main.bounds.width/2.5)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: smooth_radius, height: smooth_radius)))
                    
                    
                    
                    VStack(alignment: .subCenter, spacing: half_spacing) {
                        HStack(alignment: .top) {
                            Spacer()
                            
                            HStack {
                                Image.clockFill
                                Text(String(format: "%02d:%02d", recipe.duration/60, recipe.duration%60))
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
                                KnifeView(recipe: recipe)
                            }
                            
                            Text("・")
                                .alignmentGuide(.subCenter) { d in d.width/2 }
                            
                            HStack {
                                Image.starFill
                                Text("\(recipe.rating==0 ? String("No Ratings") : String(format: "%.1f", recipe.rating))")
                                    .modifier(Span())
                            }
                            .foregroundStyle(Color.color_text_review_primary)
                            
                            Spacer()
                        }
                    }
                    .modifier(Span())
                    
                    // TODO: componente de resizable tag collection
                    ScrollView{
                        //                        ResizableTagGroup(visualContent: vm.recipe.tags.map({ tag in
                        //                            TagView(Tag: tag.name) {
                        //                                Text("Nothing to see here yet.")
                        //                                    .modifier(Title())
                        //                                    .foregroundStyle(Color.color_text_container_highlight)
                        //                            }
                        //                        }))
                        ChipsStack {
                            ForEach(recipe.tags) { tag in
                                //                                Button {
                                //
                                //                                } label: {
                                //                                    TagView(text: tag.name, selected: .constant(true))
                                //                                }
                                TagView(text: tag.name, selected: .constant(true))
                                    .padding(.trailing, half_spacing)
                                    .padding(.bottom, half_spacing)
                            }
                        }
                    }
                    Divider()
                }
                
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
            
            if let description = recipe.desc {
                Section {
                    Text(description)
                } header: {
                    Text("Description")
                }
            }
            
            // TODO: Empty state de ingredients
            Section {
                ForEach(recipe.ingredients) { ingredient in
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
                ForEach(0..<recipe.steps.count) { idx in
                    HStack {
                        Text(recipe.steps[idx].title)
                            .foregroundStyle(Color.color_text_container_highlight)
                        
                        Spacer()
                        
                        Image.chevronRight
                            .foregroundColor(Color.color_button_container_primary)
                    }
                    .background(
                        // TODO: Ir para o player no passo escolhido
                        
                        NavigationLink(destination: RecipePlayerView(recipe: recipe, step: idx), label: {})
                    )
                }
            } header: {
                Text("Steps")
            }
            
            
            HStack {
                Spacer()
                
                Button(action: {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success {
                            print("All set!")
                            self.startRecipe()
                        } else if let error = error {
                            print(error.localizedDescription)
                        }else{
                            showAlert = true
                        }
                    }
                    
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
                            cookbook.toggleFavourite(recipe: recipe)
                        }
                        .buttonStyle(FavoriteButtonStyle(isFavorited:
                                .init(get: { cookbook.isFavoritedRecipe(recipe: recipe) },
                                      set: { value in return }))
                        )
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
        .navigationTitle(recipe.name)
        .navigationDestination(isPresented: $isNextViewActivated) {
            switch destination {
            case .Player:
                RecipePlayerView(recipe: recipe, step: 0)
            case .Edit:
                CreateEditRecipeView(recipe: recipe)
            }
            
        }
        .onAppear {
            self.vm.delegate = self
        }
        
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Permission required"), message: Text("To be able to be notified of when your timer ends, we need your permission to send you notifications. Head to your settings to allow the app to send notifications."), primaryButton: .destructive(Text("Cancel").bold(), action: {self.startRecipe()}), secondaryButton: .default(Text("Ok"), action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!); self.startRecipe()
            }))
        })
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
    func startRecipe() {
        self.isNextViewActivated = true
        self.destination = .Player
    }
    
    
    func editRecipe() {
        self.destination = .Edit
        self.isNextViewActivated = true
    }
    
    func deleteRecipe(){
        self.repo.delete(recipe.id)
        self.cookbook.removeOwned(recipe: recipe)
        self.dismiss()
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

#Preview {
    NavigationStack {
        RecipeDetailsView(recipe: Constants.mockedRecipe)
    }
    .environmentObject(Constants.mockedCookbook)
}
