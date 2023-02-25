//
//  RecipesWebRepository.swift
//  Food_Example
//
//  Created by Артур Кулик on 24.01.2023.
//

import Combine
import FirebaseDatabase
import Foundation

protocol RecipesApiRepository {
    func searchRequest<T: Decodable>(model: T.Type, params: [String: String], path: APIEndpoint) -> AnyPublisher<T, Error>
}

class RecipesApiRepositoryImpl: RecipesApiRepository {
    func searchRequest<T: Decodable>(model: T.Type, params: [String: String], path: APIEndpoint) -> AnyPublisher<T, Error> {
        guard var url = URL(string: Constants.API.baseURL + path.path) else {
            return Fail(outputType: model, failure: APIRequestError.invalidURL).eraseToAnyPublisher()
        }
        url = url.appendingQueryParameters(params)
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: model.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
