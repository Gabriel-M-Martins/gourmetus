//
//  ListType.swift
//  Gourmetus
//
//  Created by Thiago Defini on 31/10/23.
//

import Foundation

enum ListType: String, Codable {
    case History
    case Owned
    case Favorites
    
    var description: String {
        switch self {
        case .History: return "Recently Accessed"
        case .Owned: return "My Recipes"
        case .Favorites: return "Favourites Recipes"
        }
    }
    
    var description2: String {
        switch self {
        case .History: return "History of Recipes"
        case .Owned: return "Your Recipes"
        case .Favorites: return "Added to Favourites"
        }
    }
    
    static func fromString(_ string: String) -> ListType?{
        return ListType(rawValue: string)
    }
}
