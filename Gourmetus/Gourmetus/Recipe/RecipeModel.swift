//
//  RecipeModel.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 24/10/23.
//

import Foundation
import CoreData

struct RecipeModel: Identifiable{
    var id: UUID
    var name: String
    var difficulty: Float
    var desc: String?
    var imageData: Data?
    
    var steps: [StepModel]
    var ingredients: [IngredientModel]
    
    enum RecipeError: Error {
        case invalidIndex
    }
    
    init(id: UUID, name: String, desc: String? = nil, difficulty: Float, imageData: Data? = nil, steps: [StepModel], ingredients: [IngredientModel]) {
        self.id = id
        self.name = name
        self.desc = desc
        self.difficulty = difficulty
        self.imageData = imageData
        self.steps = steps
        
        self.ingredients = ingredients
        self.ingredients.sort(by: { $0.name.lowercased() < $1.name.lowercased() } )
    }
}

// MARK: - Core Data Convertable
extension RecipeModel : CoreDataCodable {
    init?(_ entity: Recipe) {
        var decoder = JSONDecoder()
        
        var ingredients = [IngredientModel]()
        if let ingredientsEntities = entity.ingredients?.allObjects as? [Ingredient] {
            for ingredient in ingredientsEntities {
                guard let name = ingredient.name,
                      let id = ingredient.id,
                      let quantity = ingredient.quantity,
                      let unitData = ingredient.unit,
                      let unit = try? decoder.decode(Unit.self, from: unitData) else {
                          continue
                      }
                
                ingredients.append(IngredientModel(id: id, name: name, quantity: quantity, unit: unit))
            }
        }
        
        var steps = [(order: Int, model: StepModel)]()
        if let stepsEntities = entity.steps?.allObjects as? [Step] {
            for step in stepsEntities {
                guard let id = step.id else { continue }
                steps.append((Int(step.order), StepModel(id: id, text: step.text, tip: step.tip, imageData: step.image, timer: step.timer)))
            }
        }
        
        steps.sort(by: {$0.order < $1.order})
        
        guard let name = entity.name,
                let id = entity.id else { return nil }
        
        self.id = id
        self.name = name
        self.difficulty = entity.difficulty
        self.steps = steps.map({ return $0.model })
        self.ingredients = ingredients
    }
    
    func encode(context: NSManagedObjectContext, existingEntity: Entity?) -> Recipe {
        let result = existingEntity != nil ? existingEntity! : Recipe(context: context)
        
        result.id = self.id
        result.name = self.name
        result.averageTime = Float()
        result.desc = self.desc
        result.difficulty = self.difficulty
        result.image = self.imageData
        
        let existingIngredients = Set(result.ingredients?.allObjects as? [Ingredient] ?? [])
        for ingredient in self.ingredients {
            let existingIngredientEntity = existingIngredients.first(where: {$0.id == ingredient.id})
            let ingredientEntity = ingredient.encode(context: context, existingEntity: existingIngredientEntity)
            
            if existingIngredientEntity == nil {
                result.addToIngredients(ingredientEntity)
            }
        }
        
        let existingSteps = Set(result.steps?.allObjects as? [Step] ?? [])
        for step in self.steps {
            let existingStepEntity = existingSteps.first(where: { $0.id == step.id })
            let stepEntity = step.encode(context: context, existingEntity: existingStepEntity)
            
            if existingStepEntity == nil {
                result.addToSteps(stepEntity)
            }
        }
        
        return result
    }
}

// MARK: - Steps
extension RecipeModel {
    mutating func addStep(step: StepModel, at position: Int) {
        var realPosition = position
        
        if realPosition < 0 {
            realPosition = 0
        }
        
        if realPosition > steps.count {
            realPosition = steps.count
        }
        
        steps.insert(step, at: realPosition)
    }
    
    mutating func removeStep(at position: Int) -> Result<(), RecipeError> {
        if position < 0 || position >= steps.count {
            return .failure(.invalidIndex)
        }
        
        self.steps.remove(at: position)
        return .success(())
    }
    
    mutating func updateStep(at position: Int, updatedStep: StepModel) -> Result<(), RecipeError> {
        if position < 0 || position >= steps.count {
            return .failure(.invalidIndex)
        }
        
        self.steps[position] = updatedStep
        
        return .success(())
    }
}

// MARK: - Ingredients
extension RecipeModel {
    mutating func addIngredient(ingredient: IngredientModel, at position: Int) {
        var realPosition = position
        
        if realPosition < 0 {
            realPosition = 0
        }
        
        if realPosition > ingredients.count {
            realPosition = ingredients.count
        }
        
        ingredients.insert(ingredient, at: realPosition)
    }
    
    mutating func removeIngredient(at position: Int) -> Result<(), RecipeError> {
        if position < 0 || position >= ingredients.count {
            return .failure(.invalidIndex)
        }
        
        self.ingredients.remove(at: position)
        return .success(())
    }
    
    mutating func updateIngredient(at position: Int, updatedIngredient: IngredientModel) -> Result<(), RecipeError> {
        if position < 0 || position >= ingredients.count {
            return .failure(.invalidIndex)
        }
        
        self.ingredients[position] = updatedIngredient
        
        return .success(())
    }
}
