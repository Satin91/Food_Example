//
//  RequestParameters.swift
//  Food_Example
//
//  Created by Артур Кулик on 24.01.2023.
//

import Combine

protocol RecipesRequestParams: Decodable {
    func URLParams() -> [String: String]
}

struct ComplexSearchParams: RecipesRequestParams {
    private var query = String()
    private var includeIngridients = String()
    private var number = Int()
    private var maxFat = Int()
    
    init(query: String, includeIngridients: String, number: Int, maxFat: Int) {
        self.query = query
        self.includeIngridients = includeIngridients
        self.number = number
        self.maxFat = maxFat
    }
    
    func URLParams() -> [String: String] {
        [
            "apiKey": Constants.API.apiKey,
            "query": query,
            "number": String(number),
            "maxFat": String(maxFat)
        ]
    }
}

extension RecipesRequestParams {
    func URLParams() -> [String: String] {
        [:]
    }
}
