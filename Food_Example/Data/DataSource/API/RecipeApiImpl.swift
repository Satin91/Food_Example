//
//  NetworkManager.swift
//  Food_Example
//
//  Created by Артур Кулик on 11.01.2023.
//

import Foundation

enum ApiServerError: Error {
    case badURL
    case badConnection
    case requestError
    case statusError
}

class RecipeApiImpl: RecipeDataSource {
    private let maxFat: Int = 140
    private let searchCount: Int = 2
    private let successStatusCode = 200
    private let query: String = "Wine"
    private let apiAddress = "https://api.spoonacular.com/recipes/complexSearch?apiKey="
    private let apiKey: String = "a053c68935284fc0b0041026bf79c509&query"
    
    func searchRecipes() async throws -> [Recipe] {
        guard var url = URL(string: "https://api.spoonacular.com/recipes/complexSearch") else {
            throw ApiServerError.badURL
        }
        let URLParams = [
            "apiKey": "a053c68935284fc0b0041026bf79c509",
            "query": query,
            "maxFat": String(maxFat),
            "number": String(searchCount)
        ]
        
        url = url.appendingQueryParameters(URLParams)
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == successStatusCode else {
            throw ApiServerError.badConnection
        }
        let recipes = try JSONDecoder().decode(RecipeApiHeaderEntity.self, from: data)
        print(recipes.results)
        return recipes.results.map { entity in
            Recipe(
                id: entity.id,
                title: entity.title,
                image: entity.image
            )
        }
    }
}
