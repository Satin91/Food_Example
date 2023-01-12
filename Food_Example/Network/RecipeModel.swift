//
//  RecipeModel.swift
//  Food_Example
//
//  Created by Артур Кулик on 11.01.2023.
//

import Foundation

struct RecipeModel: Decodable {
    var results: [Results]
}

struct Results: Decodable {
    var id: Int
    var title: String
    var image: String
}
