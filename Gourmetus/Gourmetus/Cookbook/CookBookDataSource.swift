//
//  CookBookDataSource.swift
//  Gourmetus
//
//  Created by Lucas Cunha on 24/10/23.
//

import Foundation

final class CookBookDataSource: CoreDataSource {
    typealias SourceType = Cookbook
    static var shared: CookBookDataSource = CookBookDataSource()
}
