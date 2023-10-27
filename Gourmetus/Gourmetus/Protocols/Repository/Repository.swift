//
//  Repository.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 27/10/23.
//

import Foundation

protocol Repository {
    associatedtype ModelType
    
    static func fetch() -> [ModelType]
    
    static func save(_ models: [ModelType])
    static func save(_ model: ModelType)
    
    static func delete(_ ids: [UUID])
    static func delete(_ id: UUID)
}
