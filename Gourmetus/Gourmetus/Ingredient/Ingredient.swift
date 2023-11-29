//
//  Ingredient.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 24/10/23.
//

import Foundation
import CoreData

final class Ingredient: Equatable, Identifiable, Hashable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: UUID
    var name: String
    var quantity: String
    var unit: IngredientUnit
    
    init(id: UUID = UUID(), name: String = "default ingredient", quantity: String = "default quantity", unit: IngredientUnit = .G) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.unit = unit
    }
}

enum IngredientUnit: String, Codable, Identifiable, CaseIterable {
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
