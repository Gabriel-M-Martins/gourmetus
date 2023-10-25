//
//  IngredientModel.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 24/10/23.
//

import Foundation

struct IngredientModel: Identifiable {
    var id: UUID
    var name: String
    var quantity: String
    var unit: Unit
}

enum Unit: String, Codable{
    case Cup
    case Ml
    case L
    case Kg
    case G
    
    static func fromString(_ string: String) -> Unit?{
        return Unit(rawValue: string)
    }
}
