//
//  RecipesWebRepository.swift
//  Food_Example
//
//  Created by Артур Кулик on 24.01.2023.
//

import Combine
import Foundation

protocol RecipesWebRepository {
    func searchRequest<T: Decodable>(model: T.Type, params: [String: String], path: APIEndpoint) -> AnyPublisher<T, Error>
}

class RecipesWebRepositoryImpl: RecipesWebRepository {
    var cancelBag = Set<AnyCancellable>()
    
    func searchRequest<T: Decodable>(model: T.Type, params: [String: String], path: APIEndpoint) -> AnyPublisher<T, Error> {
        guard var url = URL(string: Constants.API.baseURL + path.path) else {
            return Fail(outputType: model, failure: APIRequestError.invalidURL).eraseToAnyPublisher()
        }
        url = url.appendingQueryParameters(params)
        //        return URLSession.shared
        //            .dataTaskPublisher(for: url)
        //            .tryMap { data, _ in
        //                (try JSONSerialization.jsonObject(with: data) as! [String: Any], data)
        //            }
        //            .tryMap { dict in
        //                if dict.0.keys.contains("results") {
        //                    try JSONDecoder().decode([Recipe].self, from: dict.1)
        //                }
        //                let dec = try JSONDecoder().decode([Recipe].self, from: dict.1)
        //            }
        //            .map({ recipe in
        //                return recipe
        //            })
        //            .eraseToAnyPublisher()
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: model.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
