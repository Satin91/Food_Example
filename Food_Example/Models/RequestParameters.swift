//
//  RequestParameters.swift
//  Food_Example
//
//  Created by Артур Кулик on 24.01.2023.
//

import Combine

class RecipesRequestParams {
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
        checkAvailableData()
    }
    
    func checkAvailableData() {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children where child.label != "URLParams" {
            if let name: String = child.label {
                let value: Any = (child.value as? AnyOptional)?.objectValue ?? child.value
                switch value {
                case let obj as String:
                    URLParams[name] = obj
                case let obj as Int:
                    URLParams[name] = String(obj)
                default:
                    break
                }
            }
        }
    }
}

private protocol AnyOptional {
    var objectValue: Any? { get }
}

extension Optional: AnyOptional {
    var objectValue: Any? {
        switch self {
        case .none:
            return nil
        case .some:
            return self! as Any
        }
    }
}
