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
    
    @Published var id: UUID
    @Published var title: String
    @Published var texto: String?
    @Published var tip: String?
    @Published var imageData: Data?
    @Published var timer: Int?
    @Published var ingredients: [Ingredient]
    @Published var order: Int
    
    init(id: UUID = UUID(), title: String = "", texto: String? = nil, tip: String? = nil, imageData: Data? = nil, timer: Int? = nil, ingredients: [Ingredient] = [], order: Int = -1) {
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
