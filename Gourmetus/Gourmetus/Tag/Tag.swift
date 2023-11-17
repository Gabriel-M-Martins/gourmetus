//
//  Tag.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 08/11/23.
//

import Foundation

final class Tag : Identifiable {
    let id: UUID
    let name: String
    
    var recipes: [Recipe]
    
    init(id: UUID = UUID(), name: String, recipes: [Recipe] = []) {
        self.id = id
        self.name = name
        self.recipes = recipes
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        lhs.id == rhs.id
    }
}
