//
//  RecipesWebRepository.swift
//  Food_Example
//
//  Created by Артур Кулик on 24.01.2023.
//

import Combine
import Foundation

protocol RecipesWebRepository {
    func searchRecipes<T: Decodable>(model: T.Type, params: [String: String], path: ApiEndpoint) throws -> AnyPublisher<T, Error>
}

class RecipesWebRepositoryImpl: RecipesWebRepository {
    var cancelBag = Set<AnyCancellable>()
    
    func searchRecipes<T: Decodable>(model: T.Type, params: [String: String], path: ApiEndpoint) throws -> AnyPublisher<T, Error> {
        guard var url = URL(string: Constants.API.baseURL + path.path) else { throw NetworkRequestError.invalidURL }
        url = url.appendingQueryParameters(params)
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: model.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

enum NetworkRequestError: Swift.Error {
    case invalidURL
    case serverError
    case unexpectedResponse
}

enum ApiEndpoint {
    case searchByName
    case searchByIngridient
    case pecipeInfo(String)
    
    var path: String {
        switch self {
        case .searchByName:
            return "complexSearch"
        case .searchByIngridient:
            return "findByIngredients"
        case .pecipeInfo:
            return "information"
        }
    }
}
