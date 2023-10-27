//
//  IngredientModel.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 24/10/23.
//

import Foundation

struct IngredientModel {
    var name: String
    var quantity: String
    var unit: Unit
}

enum Unit: Codable {
    case Cup
    case Ml
    case L
    case Kg
    case G
}
