//
//  RequestParameters.swift
//  Food_Example
//
//  Created by Артур Кулик on 24.01.2023.
//

import Combine

struct RecipesRequestParams {
    private var query: String?
    private var includeIngridients: String? {
        didSet {
            updateParams(key: "key")
        }
    }
    private var number: Int? {
        didSet {
            updateParams(key: "key")
        }
    }
    private var maxFat: Int? {
        didSet {
            updateParams(key: "key")
        }
    }
    var URLParams = ["apiKey": Constants.API.apiKey]
    
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
    mutating func updateParams(key: String) {
        let mirror = Mirror(reflecting: self)
        print("________________")
        mirror.children.forEach { child in
            let str = String.StringLiteralType(describing: child.value)
            print(str)
        }
    }
}
