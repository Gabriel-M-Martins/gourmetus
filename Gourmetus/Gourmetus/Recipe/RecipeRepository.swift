//
//  RecipeRepository.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 24/10/23.
//

import Foundation
import CoreData

// MARK: - Core Data
final class CoreDataRecipeRepository: CoreDataRepository {
    static var cache: [UUID : Recipe] = [:]
    
    typealias DataSource = RecipeDataSource
    typealias Model = RecipeModel
}
