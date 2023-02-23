//
//  RequestParameters.swift
//  Food_Example
//
//  Created by Артур Кулик on 24.01.2023.
//

import Combine

class RecipesRequestParams {
    var URLParams = [
        "apiKey": Constants.API.apiKey,
        "number": "35"
    ]
    
    init(urlParams: [String: String]) {
        clearParams()
        urlParams.forEach { URLParams[$0.key] = $0.value }
    }
    
    // this is needed to clean up the previous search query
    func clearParams() {
        self.URLParams = [
            "apiKey": Constants.API.apiKey,
            "number": "35"
        ]
    }
}
