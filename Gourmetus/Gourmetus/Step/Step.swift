//
//  Step.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 24/10/23.
//

import Foundation
import CoreData

struct Step: Identifiable, Hashable {
    var id: UUID
    var title: String
    var texto: String?
    var tip: String?
    var imageData: Data?
    var timer: Int?
    var order: Int
}
