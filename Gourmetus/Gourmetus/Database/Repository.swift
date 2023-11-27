//
//  Repository.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 27/10/23.
//

import Foundation

protocol Repository<Model> {
    associatedtype Model
    func fetch() -> [Model]
    func fetch(id: UUID) -> Model?
    func save(_ model: Model)
    func save(_ models: [Model])
    func delete(_ model: Model)
}
