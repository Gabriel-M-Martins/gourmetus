//
//  ListType.swift
//  Gourmetus
//
//  Created by Thiago Defini on 31/10/23.
//

import Foundation

enum ListType: String, Codable {
    case RecentlyAccessed
    case MyRecipes
    case FavouritesRecipes
    
    var description: String {
        switch self {
        case .RecentlyAccessed: return "Recently Accessed"
        case .MyRecipes: return "My Recipes"
        case .FavouritesRecipes: return "Favourites Recipes"
        }
    }
    
    var description2: String {
        switch self {
        case .RecentlyAccessed: return "History of Recipes"
        case .MyRecipes: return "Your Recipes"
        case .FavouritesRecipes: return "Added to Favourites"
        }
    }
    
    static func fromString(_ string: String) -> ListType?{
        return ListType(rawValue: string)
    }
}
