//
//  DefaultRecipesUtility.swift
//  Gourmetus
//
//  Created by Gabriel Medeiros Martins on 28/11/23.
//

import Foundation

public class DefaultRecipesUtility {
    static func fetch(_ completionBlock: @escaping ([Recipe]) -> ()) {
        guard let url = URL(string: "https://raw.githubusercontent.com/Gabriel-M-Martins/gourmetus/dev/recipes.json") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String : Any],
                  let recipesJSON = json["recipes"] as? [ [String : Any] ],
                  error == nil else {
                
                print("error:", error as Any)
                return
            }
            
            var recipes = [EntityRepresentation]()
            var tags = [EntityRepresentation]()
            
            for recipe in recipesJSON {
                guard let name = recipe["name"],
                      let difficulty = recipe["difficulty"],
                      let rating = recipe["rating"],
                      let duration = recipe["duration"] else { continue }
                
                let recipeRepresentation: EntityRepresentation = EntityRepresentation(id: UUID(), entityName: "RecipeEntity", values: [:], toOneRelationships: [:], toManyRelationships: [:])
                recipes.append(recipeRepresentation)
                
                var recipeValues: [String : Any] = [
                    "name" : name,
                    "difficulty" : difficulty,
                    "rating" : rating,
                    "duration" : duration,
                    "completed" : false
                ]
                
                if let imageLink = recipe["image"] as? String,
                   let imageURL = URL(string: imageLink),
                   let imageData = try? Data(contentsOf: imageURL) {
                    recipeValues.updateValue(imageData, forKey: "image")
                }
                
                if let desc = recipe["desc"] as? String {
                    recipeValues.updateValue(desc, forKey: "desc")
                }
                
                recipeRepresentation.values = recipeValues
                recipeRepresentation.toManyRelationships.updateValue([], forKey: "steps")
                recipeRepresentation.toManyRelationships.updateValue([], forKey: "tags")
                recipeRepresentation.toManyRelationships.updateValue([], forKey: "ingredients")
                
                var ingredients = [EntityRepresentation]()
                
                guard let stepsJSON = recipe["steps"] as? [ [String : Any] ] else { continue }
                for i in 0..<stepsJSON.count {
                    let stepRepresentation: EntityRepresentation = EntityRepresentation(id: UUID(), entityName: "StepEntity", values: [:], toOneRelationships: [:], toManyRelationships: [:])
                    recipeRepresentation.toManyRelationships["steps"]?.append(stepRepresentation)
                    
                    // Catando todos os valores
                    guard let title = stepsJSON[i]["title"] else { continue }
                    var stepValues: [String : Any] = [
                        "title" : title,
                        "order" : i
                    ]
                    
                    if let texto = stepsJSON[i]["texto"] as? String {
                        stepValues.updateValue(texto, forKey: "texto")
                    }
                    
                    if let tip = stepsJSON[i]["tip"] as? String {
                        stepValues.updateValue(tip, forKey: "tip")
                    }
                    
                    if let timer = stepsJSON[i]["timer"] as? Int {
                        stepValues.updateValue(timer, forKey: "timer")
                    }
                    
                    if let imageLink = stepsJSON[i]["image"] as? String,
                       let imageURL = URL(string: imageLink),
                       let imageData = try? Data(contentsOf: imageURL) {
                        stepValues.updateValue(imageData, forKey: "image")
                    }
                    
                    // Coloca todos os valores dentro da representação
                    stepRepresentation.values = stepValues
                    stepRepresentation.toManyRelationships.updateValue([], forKey: "ingredients")
                    
                    // Catando os ingredientes
                    guard let ingredientsJSON = stepsJSON[i]["ingredients"] as? [ [String : Any] ] else { continue }
                    for j in 0..<ingredientsJSON.count {
                        let encoder = JSONEncoder()
                        guard let name = ingredientsJSON[j]["name"] as? String,
                              let quantity = ingredientsJSON[j]["quantity"] as? String,
                              let unitStr = ingredientsJSON[j]["unit"] as? String,
                              let unit = IngredientUnit(rawValue: unitStr),
                              let unitData = try? encoder.encode(unit) else { continue }
                        
                        if ingredients.contains(where: { ($0.values["name"] as? String) == name }) { continue }
                        
                        let ingredientRepresentation = EntityRepresentation(id: UUID(), entityName: "IngredientEntity", values: [:], toOneRelationships: [:], toManyRelationships: [:])
                        ingredients.append(ingredientRepresentation)
                        
                        let values: [String : Any] = [
                            "name" : name,
                            "quantity" : quantity,
                            "unit" : unitData
                        ]
                        
                        ingredientRepresentation.values = values
                        stepRepresentation.toManyRelationships["ingredients"]?.append(ingredientRepresentation)
                    }
                }
                
                recipeRepresentation.toManyRelationships["ingredients"] = ingredients
                
                guard let tagsJSON = recipe["tags"] as? [String] else { continue }
                for tagName in tagsJSON {
                    if let existentTagIdx = tags.firstIndex(where: { ($0.values["name"] as? String) == tagName }) {
                        tags[existentTagIdx].toManyRelationships["recipes"]?.append(recipeRepresentation)
                        recipeRepresentation.toManyRelationships["tags"]?.append(tags[existentTagIdx])
                        continue
                    }
                    
                    let tagRepresentation = EntityRepresentation(id: UUID(), entityName: "TagEntity", values: [:], toOneRelationships: [:], toManyRelationships: [:])
                    tags.append(tagRepresentation)
                    recipeRepresentation.toManyRelationships["tags"]?.append(tagRepresentation)
                    
                    tagRepresentation.values = [
                        "name" : tagName
                    ]
                    
                    tagRepresentation.toManyRelationships = [
                        "recipes" : [recipeRepresentation]
                    ]
                }
            }
            
            var result = [Recipe]()
            var visited: [UUID : (any EntityRepresentable)?] = [:]
            for recipe in recipes {
                guard let model = Recipe.decode(representation: recipe, visited: &visited) else { continue }
                result.append(model)
            }
            
            DispatchQueue.main.async {
                completionBlock(result)
            }
        }
        .resume()
    }
}
