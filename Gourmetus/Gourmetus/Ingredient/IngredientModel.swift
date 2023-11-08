//
//  Ingredient.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 24/10/23.
//

import Foundation
import CoreData

struct Ingredient: Equatable, Identifiable, Hashable{
    var id: UUID
    var name: String
    var quantity: String
    var unit: IngredientUnit
}

enum IngredientUnit: Codable, Identifiable, CaseIterable {
    var id: Self {

           return self
       }
    
    case Cup
    case Ml
    case L
    case Kg
    case G
    
    var description: String {
        switch self {
        case .Cup:
            return "Cup"
        case .Ml:
            return "Ml"
        case .L:
            return "L"
        case .Kg:
            return "Kg"
        case .G:
            return "G"
        }
    }
}
