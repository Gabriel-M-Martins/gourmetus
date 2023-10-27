//
//  CookBookRepository.swift
//  Gourmetus
//
//  Created by Lucas Cunha on 25/10/23.
//

import Foundation

protocol CookBookRepository{
    func fetch()
    func save()
}

final class CoreDataCookBookRepository: CookBookRepository{
    var source = CookBookDataSource()
    func fetch() {
        guard var entities = try? source.fetch(),
        var cookBookEntity = entities.first else {return}
        var cookBookModel = CookBookModel(favorites: [], latest: [])
        for favorite in cookBookEntity.favorites?.allObjects as? [Recipe] ?? [] {
            guard var nameAux = favorite.name,
                  var steps = favorite.steps?.allObjects as? [StepModel],
                  var ingredientsAux = favorite.ingredients?.allObjects as? [IngredientModel] else {return}
            var recipe = RecipeModel(name: nameAux, difficulty: favorite.difficulty, steps: steps, ingredients: ingredientsAux)
            cookBookModel.favorites.append(recipe)
        }
        
        for latest in cookBookEntity.latest?.allObjects as? [Recipe] ?? [] {
            guard var nameAux = latest.name,
                  var steps = latest.steps?.allObjects as? [StepModel],
                  var ingredientsAux = latest.ingredients?.allObjects as? [IngredientModel] else {return}
            var recipe = RecipeModel(name: nameAux, difficulty: latest.difficulty, steps: steps, ingredients: ingredientsAux)
            cookBookModel.latest.append(recipe)
        }
    }
    
    func save() {
        <#code#>
    }
    
    
}
