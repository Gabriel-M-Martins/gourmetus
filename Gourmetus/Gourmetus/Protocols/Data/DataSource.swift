//
//  DataSource.swift
//  DemoCleanMVVM
//
//  Created by Gabriel Medeiros Martins on 24/10/23.
//

import Foundation

protocol DataSource<T> {
    associatedtype T
    func fetch() throws -> [T]
}

