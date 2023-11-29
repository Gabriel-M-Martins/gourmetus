//
//  TagView.swift
//  Gourmetus
//
//  Created by Lucas Cunha on 07/11/23.
//

import SwiftUI

struct TagView: View{
    
    @State var text : String

    @Binding var selected: Bool
    
    var body: some View {
        Text(LocalizedStringKey(text))
            .modifier(Span())
            .foregroundStyle(selected ? Color.color_general_fixed_light : Color.color_text_container_primary)
            .padding(.vertical, half_spacing)
            .padding(.horizontal, default_spacing)
            .lineLimit(1)
            .background {
                if selected {
                    RoundedRectangle(cornerRadius: hard_radius)
                        .fill(Color.color_button_container_primary)
                } else {
                    RoundedRectangle(cornerRadius: hard_radius)
                        .strokeBorder(Color.color_button_container_primary, lineWidth: 2)
                }
            }
    }
}

#Preview {
    TagView(text: "fo caralho porra", selected: .constant(true))
}
