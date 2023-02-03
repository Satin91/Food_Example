//
//  NetworkHelpers.swift
//  Food_Example
//
//  Created by Артур Кулик on 26.01.2023.
//

import Foundation

enum APIEndpoint {
    case searchInAll
    case searchByIngridient
    case searchByNutritients
    case recipeInfo(Int)
    case nutritions(Int)
    case ingridients(Int)
    
    var path: String {
        switch self {
        case .searchInAll:
            return "complexSearch"
        case .searchByIngridient:
            return "findByIngredients"
        case .searchByNutritients:
            return "findByNutrients"
        case .recipeInfo(let id):
            return "\(id)/" + "information"
        case .nutritions(let id):
            return "\(id)/" + "nutritionWidget.json"
        case .ingridients(let id):
            return "\(id)/" + "ingredientWidget.json"
        }
    }
    
    var text: String {
        switch self {
        case .searchInAll:
            return "Search in all categories"
        case .searchByIngridient:
            return "Search by ingredients"
        case .searchByNutritients:
            return "Search by nutritients"
        default:
            return ""
        }
    }
}

enum APIRequestError: Error {
    case invalidURL
    case serverError
    case unexpectedResponse
    case imageDeserialization
}
