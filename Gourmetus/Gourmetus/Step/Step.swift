//
//  Step.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 24/10/23.
//

import Foundation
import CoreData

final class Step: ObservableObject, Identifiable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func == (lhs: Step, rhs: Step) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: UUID
    var title: String
    var texto: String?
    var tip: String?
    var imageData: Data?
    var timer: Int?
    var ingredients: [Ingredient]
    var order: Int
    
    init(id: UUID = UUID(), title: String = "default", texto: String? = nil, tip: String? = nil, imageData: Data? = nil, timer: Int? = nil, ingredients: [Ingredient] = [], order: Int = -1) {
        self.id = id
        self.title = title
        self.texto = texto
        self.tip = tip
        self.imageData = imageData
        self.timer = timer
        self.ingredients = ingredients
        self.order = order
    }
}
