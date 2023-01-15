//
//  RecipeApiEntity.swift
//  Food_Example
//
//  Created by Артур Кулик on 15.01.2023.
//

import Foundation

struct RecipeApiHeaderEntity: Decodable {
    var results: [RecipeApiEntity]
}

struct RecipeApiEntity: Decodable {
    var id: Int
    var title: String
    var image: String
}