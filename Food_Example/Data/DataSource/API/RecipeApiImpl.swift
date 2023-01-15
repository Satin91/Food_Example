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
    private let searchCount: Int = 120
    private let successStatusCode = 200
    private let searchWord: String = "Wine"
    private let apiAddress = "https://api.spoonacular.com/recipes/complexSearch?apiKey="
    private let apiKey: String = "a053c68935284fc0b0041026bf79c509&query"

    func getRecipe() async throws -> [Recipe] {
        let stringUrl = "\(apiAddress)\(apiKey)=\(searchWord)&maxFat=" + "\(maxFat)" + "&number=" + "\(maxFat)"
        guard let url = URL(string: stringUrl) else {
            throw ApiServerError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == successStatusCode else {
            throw ApiServerError.badConnection
        }
        
        let recipes = try JSONDecoder().decode(RecipeApiHeaderEntity.self, from: data)
        
        return recipes.results.map { entity in
            Recipe(
                id: entity.id,
                title: entity.title,
                image: entity.image
            )
        }
    }
}
