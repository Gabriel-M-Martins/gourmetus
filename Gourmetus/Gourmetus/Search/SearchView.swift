//
//  SearchView.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 13/11/23.
//

import SwiftUI

class TagFilterSearchViewModel: ObservableObject {
    @Injected private var repo: any Repository<Tag>
    
    @Published var tags: [Tag] = []
    
    func fetchTags() {
        self.tags = repo.fetch()
        
        if self.tags.isEmpty {
            self.tags = Constants.mockedTags
            repo.save(self.tags)
        }
    }
}

struct TagFilterSearchView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var vm: TagFilterSearchViewModel = TagFilterSearchViewModel()
    
    @Binding var selectedTags: Set<String>
    
    func toggleTag(_ tag: Tag) {
        if selectedTags.contains(tag.name) {
            selectedTags.remove(tag.name)
        } else {
            selectedTags.insert(tag.name)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Filters")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .foregroundStyle(Color.color_text_container_primary)
                }
            }
            .padding(default_spacing)
            
            ChipsStack {
                ForEach(vm.tags) { tag in
                    Button {
                        withAnimation {
                            toggleTag(tag)
                        }
                    } label: {
                        TagView(text: tag.name,
                                selected: .init(
                                    get: { selectedTags.contains(tag.name) },
                                    set: { value in return }))
                    }
                    .padding(.trailing, half_spacing)
                    .padding(.bottom, half_spacing)
                }
            }
            .padding(.horizontal, default_spacing)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Apply")
                    .modifier(Header())
                    .frame(width: UIScreen.main.bounds.width / 2)
            }
            .padding(.top, half_spacing)
            .tint(Color.color_button_container_primary)
            .buttonStyle(.borderedProminent)
            
            Button {
                withAnimation {
                    selectedTags = []
                }
            } label: {
                Text("Clear")
                    .modifier(Link())
                    .frame(width: UIScreen.main.bounds.width / 2)
            }
            .padding(.top, half_spacing/2)
            .tint(Color.color_general_destructive)
            
        }
        .onAppear {
            vm.fetchTags()
        }
        .presentationDetents([.fraction(1/2.5), .medium, .large])
        .presentationDragIndicator(.visible)
    }
}
