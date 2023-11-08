//
//  EntityRepresentation.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 07/11/23.
//

import Foundation

/// The half-way between the structs used on the app views and business logic and the entities stored on databases.
struct EntityRepresentation {
    /// Shared Id between databases to ensure data consistency.
    let id: UUID
    /// Name of the entity stored on the databases. All databases used should share the same entity names.
    /// Probably this is going to be modified in the future to be a custom struct that can specify names accordingly to the database.
    /// that is being used.
    let entityName: String
    /// The properties the entity has. Probably this is going to be modified in the future to be a custom struct that can specify properties
    /// types accordingly to the database.
    let values: [String : Any] // [String: PrimitiveValue]
    /// This should **only** map to children relationships and **never** to parent relationships as to avoid
    /// infinite mapping loops.
    let toOneRelationships: [String : EntityRepresentation]
    /// This should **only** map to children relationships and **never** to parent relationships as to avoid
    /// infinite mapping loops.
    let toManyRelationships: [String : [EntityRepresentation]]
}

/// Structs that are going to be stored in a database should implement this protocol to proper map the communication with *any* database.
protocol EntityRepresentable: Hashable {
    init?(entityRepresentation: EntityRepresentation)
    func encode() -> EntityRepresentation
}
