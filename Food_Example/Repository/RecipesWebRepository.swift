//
//  RecipesWebRepository.swift
//  Food_Example
//
//  Created by Артур Кулик on 23.01.2023.
//

import Combine
import Foundation

enum ApiServerError: Error {
    case badURL
    case badConnection
    case requestError
    case statusError
}

protocol RecipesWebRepository {
    func showRandomRecipes()
    func searchRecipesBy(query: String)
    func getRecipeInfo()
}

class RecipesWebRepositoryImpl: RecipesWebRepository {
    private let maxFat: Int = 140
    private let searchCount: Int = 150
    private let successStatusCode = 200
    private let query: String = "Potatoes"
    
    func showRandomRecipes() async throws -> [Recipe] {
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
        let recipes = try JSONDecoder().decode(SearchRecipesWrapper.self, from: data)
        
        return recipes.results
    }
    
    func getRecipes(model: Any) -> Any {
        model
    }
    
    func searchRecipesBy(query: String) async throws -> [Recipe] {
        _ = getRecipes(model: [Recipe].self)
        return []
    }
    
    func getRecipes() {
    }
    func showRandomRecipes() {
    }
    
    func searchRecipesBy(query: String) {
    }
    
    func getRecipeInfo() {
    }
}
