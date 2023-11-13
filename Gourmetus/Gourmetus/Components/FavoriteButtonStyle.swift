//
//  FavoriteButtonStyle.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 13/11/23.
//

import Foundation
import SwiftUI

struct FavoriteButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            if configuration.isPressed {
                Circle()
                    .frame(height: UIScreen.main.bounds.width * 0.1)
                    .foregroundColor(.white)
                    .modifier(cardShadow())
            } else {
                Circle()
                    .frame(height: UIScreen.main.bounds.width * 0.1)
                    .foregroundColor(.color_button_container_primary)
                    .modifier(cardShadow())
            }
            
            Image.heartFill
                .resizable()
                .foregroundColor(.color_general_fixed_light)
                .scaledToFit()
                .frame(height: UIScreen.main.bounds.width * 0.045)
        }
    }
}
