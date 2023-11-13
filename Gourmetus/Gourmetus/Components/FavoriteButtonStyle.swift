//
//  FavoriteButtonStyle.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 13/11/23.
//

import Foundation
import SwiftUI

struct FavoriteButtonStyle: ButtonStyle {
    @Binding var isFavorited: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            if isFavorited {
                Circle()
                    .frame(height: UIScreen.main.bounds.width * 0.1)
                    .foregroundColor(configuration.isPressed ? .white : .color_button_container_primary)
                    .modifier(cardShadow())
                
                Image.heartFill
                    .resizable()
                    .foregroundColor(.color_general_fixed_light)
                    .scaledToFit()
                    .frame(height: UIScreen.main.bounds.width * 0.045)
            } else {
                Circle()
                    .strokeBorder(configuration.isPressed ? .white : .color_button_container_primary, lineWidth: 2)
                    .frame(height: UIScreen.main.bounds.width * 0.1)
                    .modifier(cardShadow())
                
                Image.heart
                    .resizable()
                    .foregroundStyle(configuration.isPressed ? .white : .color_button_container_primary)
                    .scaledToFit()
                    .frame(height: UIScreen.main.bounds.width * 0.045)
            }
        }
    }
}
