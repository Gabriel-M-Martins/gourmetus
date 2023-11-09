//
//  Constants.swift
//  Recipefy
//
//  Created by Mateus Moura Godinho on 07/11/23.
//  Copyright © 2023 Godinho. All rights reserved.
//

import Foundation
import SwiftUI

var hugeFontSize = 50.0
var titleFontSize = 36.0
var headerFontSize = 20.0
var bodyFontSize = 14.0
var spanFontSize = 10.0

var smooth_radius = 20.0
var hard_radius = 5.0
var default_spacing = 16.0
var half_spacing = 8.0

extension Color{
    static let color_general_fixed_light = Color("brandWhite")
    static let color_general_fixed_dark = Color("brandBlack")
    static let color_card_container_stroke = Color("brandLightGray")
    static let color_text_container_highlight = Color("brandGreen")
    static let color_button_container_primary = Color("brandOrange")
    static let color_background_container_primary = Color("color-background-container-primary")
    static let color_text_container_primary = Color("color-text-container-primary")
    static let color_text_container_muted = Color("brandGray")
    static let color_text_review_primary = Color("systemYellow")
    static let color_general_destructive = Color("systemRed")
    static let color_image_container_empty = Color("brandLightGray")
}

extension Image{
    static let heartFill = Image(systemName: "heart.fill")
    static let heart = Image(systemName: "heart")
    static let personFill = Image(systemName: "person.fill")
    static let personCircle = Image(systemName: "person.circle")
    static let chevronRight = Image(systemName: "chevron.right")
    static let chevronLeft = Image(systemName: "chevron.left")
    static let knife = Image("Knife")
    static let textBookClosedFill = Image(systemName: "text.book.closed.fill")
    static let plus = Image(systemName: "plus")
    static let starFill = Image(systemName: "star.fill")
    static let clockFill = Image(systemName: "clock.fill")
    static let pencil = Image(systemName: "pencil")
    static let forkKnife = Image(systemName: "fork.knife")
    static let stoveFill = Image(systemName: "stove.fill")
    static let photo = Image(systemName: "photo")
    static let ellipsisCircle = Image(systemName: "ellipsis.circle")
    static let timer = Image(systemName: "timer")
    static let pauseCircle = Image(systemName: "pause.circle")
    static let playCircle = Image(systemName: "play.circle")
    static let repeatCircle = Image(systemName: "repeat.circle")
    
    static let bookFavourites = Image("Livro Favoritos")
    static let bookMyRecipes = Image("Livro Minhas Receitas")
    static let bookHistory = Image("Livro Historico")
}

struct Header: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("SF Pro", size: headerFontSize)).fontWeight(.medium)
    }
}
struct Body: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("SF Pro", size: bodyFontSize)).fontWeight(.regular)
    }
}
struct Span: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("SF Pro", size: spanFontSize)).fontWeight(.regular).textCase(.uppercase)
    }
}
struct Huge: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("SF Pro", size: hugeFontSize)).fontWeight(.medium)
    }
}
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("SF Pro", size: titleFontSize)).fontWeight(.light)
    }
}

struct cardShadow: ViewModifier {
    var radius = 4.0
    func body(content: Content) -> some View {
        content
            .shadow(color: Color("Shadow").opacity(0.25), radius: radius, x: 0, y: 0)
    }
}
