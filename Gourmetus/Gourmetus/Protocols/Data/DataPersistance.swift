//
//  DataPersistance.swift
//  DemoCleanMVVM
//
//  Created by Gabriel Medeiros Martins on 24/10/23.
//

import Foundation

protocol DataPersistence<T> {
    associatedtype T
    func save() throws
    func delete(_ object: T)
}
