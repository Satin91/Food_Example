//
//  NetworkHelpers.swift
//  Food_Example
//
//  Created by Артур Кулик on 26.01.2023.
//

import Foundation

enum APIEndpoint {
    case searchByName
    case searchByIngridient
    case recipeInfo(Int)
    
    var path: String {
        switch self {
        case .searchByName:
            return "complexSearch"
        case .searchByIngridient:
            return "findByIngredients"
        case .recipeInfo(let id):
            return "\(id)/" + "information"
        }
    }
}

enum APIRequestError: Swift.Error {
    case invalidURL
    case serverError
    case unexpectedResponse
    case imageDeserialization
}
