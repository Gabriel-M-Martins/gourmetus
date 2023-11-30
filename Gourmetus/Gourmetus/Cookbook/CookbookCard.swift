//
//  CookbookCard.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 09/11/23.
//

import SwiftUI

struct CookbookCard<Content: View>: View {
    enum BookImage {
        case ownedRecipes
        case history
        case favorites
        
        var image: Image {
            switch self {
            case .ownedRecipes:
                Image.bookMyRecipes
            case .history:
                Image.bookHistory
            case .favorites:
                Image.bookFavorites
            }
        }
    }
    
    var title: String
    var subtitle: String
    let book: BookImage
    
    @ViewBuilder let destination: Content
    
    var body: some View {
        VStack {
            NavigationLink {
                destination
            } label: {
                book.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            
            HStack {
                Text(LocalizedStringKey(title))
                    .modifier(Paragraph())
                    .foregroundStyle(Color.color_text_container_primary)
                
                Spacer()
            }
            
            HStack(spacing: 4) {
                Text(subtitle)
                Text(LocalizedStringKey("Recipes Inside"))
                
                Spacer()
            }
            .modifier(Span())
            .foregroundStyle(Color.color_text_container_muted)
        }
        .padding(.vertical, default_spacing)
    }
}


#Preview {
    CookbookCard(title: "Preview", subtitle: "Truly a preview", book: .favorites, destination: {
        Text("Lá ele")
    })
}
