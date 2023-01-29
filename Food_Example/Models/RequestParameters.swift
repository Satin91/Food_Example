//
//  RequestParameters.swift
//  Food_Example
//
//  Created by Артур Кулик on 24.01.2023.
//

import Combine

struct RecipesRequestParams {
    private var query: String?
    private var includeIngridients: String?
    private var number: Int?
    private var maxFat: Int?
    var URLParams = [
        "apiKey": Constants.API.apiKey,
        "number": "35"
    ]
    
    init(
        query: String? = nil,
        includeIngridients: String? = nil,
        number: Int? = nil,
        maxFat: Int? = nil
    ) {
        self.query = query
        self.includeIngridients = includeIngridients
        self.number = number
        self.maxFat = maxFat
    }
}
