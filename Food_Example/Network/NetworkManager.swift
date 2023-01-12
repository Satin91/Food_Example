//
//  NetworkManager.swift
//  Food_Example
//
//  Created by Артур Кулик on 11.01.2023.
//

import Foundation

enum StatusCodeError: Error {
    case badURL
    case badConnection
}

class NetworkManager {
    private let maxFat: Int = 140
    private let searchCount: Int = 120
    private let searchWord: String = "Wine"
    private let apiAddress = "https://api.spoonacular.com/recipes/complexSearch?apiKey="
    private let apiKey: String = "a053c68935284fc0b0041026bf79c509&query"
    
    
    private func fetchRecipes(url: URL) async throws -> [Results] {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw StatusCodeError.badConnection
        }
        
        let recipes = try JSONDecoder().decode(RecipeModel.self, from: data)
        
//
//        guard let recipes = String(data: data, encoding: .utf8) else {
//            throw StatusCodeError.badURL
//        }
        
        return recipes.results
    }
    
    public func getResult() async throws -> [Results] {
        let stringUrl = "\(apiAddress)\(apiKey)=\(searchWord)&maxFat=" + "\(maxFat)" + "&number=" + "\(maxFat)"
        
        guard let url = URL(string: stringUrl) else {
            throw StatusCodeError.badURL
        }
        
        let recipes = try await fetchRecipes(url: url)
        
        return recipes
    }
}
