//
//  RecipeDataSource.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 24/10/23.
//

import Foundation

final class RecipeDataSource: CoreDataSource {
    typealias SourceType = Recipe
    static var shared: RecipeDataSource = RecipeDataSource()
}

