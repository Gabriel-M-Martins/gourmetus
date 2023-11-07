//
//  RecipesListsViewModel.swift
//  Gourmetus
//
//  Created by Thiago Defini on 31/10/23.
//

import Foundation

class RecipesListsViewModel: ObservableObject{
    
    @Published var listType: ListType
    
    @Published var homeViewModel: HomeViewModel
    
    init(listType: ListType, homeviewModel: HomeViewModel) {
        self.listType = listType
        self.homeViewModel = homeviewModel
    }
}
