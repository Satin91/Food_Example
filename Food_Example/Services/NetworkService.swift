//
//  NetworkService.swift
//  Food_Example
//
//  Created by Артур Кулик on 24.01.2023.
//

import Combine
import Foundation

enum NetworkRequestError: Error {
    case invalidURL
    case serverError
    case unexpectedResponse
}

protocol NetworkRequestParams {
    var URLParams: [String: String] { get }
}

extension NetworkRequestParams {
    var apiKey: String {
        "a053c68935284fc0b0041026bf79c509"
    }
}

struct ComplexSearchParams: NetworkRequestParams {
    private var query = String()
    private var includeIngridients = String()
    private var number = Int()
    private var maxFat = Int()
    var URLParams: [String: String] {
        [
            "apiKey": apiKey,
            "query": query,
            "includeIngridients": includeIngridients,
            "number": String(number),
            "maxFat": String(maxFat)
        ]
    }
    
    init(query: String, includeIngridients: String, number: Int, maxFat: Int) {
        self.query = query
        self.includeIngridients = includeIngridients
        self.number = number
        self.maxFat = maxFat
    }
}

protocol NetworkService {
    var session: URLSession { get }
    var baseURL: String { get }
    var queue: DispatchQueue { get }
    
    func searchRecipes<T: Decodable>(model: T.Type, params: NetworkRequestParams) throws
}

class NetworkServiceImpl: NetworkService {
    var session: URLSession
    var baseURL: String
    var queue: DispatchQueue
    var cancelBag = Set<AnyCancellable>()
    
    init(session: URLSession, baseURL: String, queue: DispatchQueue) {
        self.session = session
        self.baseURL = baseURL
        self.queue = queue
    }
    
    func searchRecipes<T>(model: T.Type = T.self, params: NetworkRequestParams) throws where T: Decodable {
        guard var url = URL(string: baseURL) else {
            throw NetworkRequestError.invalidURL
        }
        url = url.appendingQueryParameters(params.URLParams)
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput(output:))
            .decode(type: model, decoder: JSONDecoder())
            .sink { error in
                print("Error \(error)")
            } receiveValue: { data in
                print(data)
            }
            .store(in: &cancelBag)
    }
    
    func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let httpResponse = output.response as? HTTPURLResponse, Array(200..<300).contains(httpResponse.statusCode) else {
            throw NetworkRequestError.serverError
        }
        return output.data
    }
}

extension URLSession {
    struct NetworkResponse<Wrapped: Decodable>: Decodable {
        var result: Wrapped
    }
    
    func publisher<T: Decodable>(
        for url: URL,
        responseType: T.Type = T.self,
        decoder: JSONDecoder = .init()
    ) -> AnyPublisher<T, Error> {
        dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: NetworkResponse<T>.self, decoder: decoder)
            .map(\.result)
            .eraseToAnyPublisher()
    }
}
