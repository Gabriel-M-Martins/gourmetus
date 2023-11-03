//
//  RecipesListsViewModel.swift
//  Gourmetus
//
//  Created by Thiago Defini on 31/10/23.
//

import Foundation

class RecipesListsViewModel: ObservableObject{
    
    var listType: ListType
    
    
    init(listType: ListType) {
        self.listType = listType
    }
}
