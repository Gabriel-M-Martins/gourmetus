//
//  CookBookRepository.swift
//  Gourmetus
//
//  Created by Lucas Cunha on 25/10/23.
//

import Foundation


final class CoreDataCookBookRepository: CoreDataRepository {
    static var cache: [UUID : Cookbook] = [:]
    
    typealias DataSource = CookBookDataSource
    typealias Model = CookBookModel
}
