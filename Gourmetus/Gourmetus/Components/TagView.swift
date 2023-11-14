//
//  TagView.swift
//  Gourmetus
//
//  Created by Lucas Cunha on 07/11/23.
//

import SwiftUI

struct TagView<Content: View>: View{
    
    @State var Tag : String
    @ViewBuilder let destination: Content
    var width : CGFloat = 10
    var height : CGFloat = 40
    
    var body: some View {
        NavigationLink {
            destination
        } label: {
            Text(Tag)
                .foregroundStyle(.black)
                .frame(width: 50 + width*CGFloat(Tag.count),height: height)
                .lineLimit(1)
                .overlay(RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.orange, lineWidth: 3))
        }
    }
}

    #Preview {
        TagView(Tag: "EASY", destination: {Text("Algo")})
    }
