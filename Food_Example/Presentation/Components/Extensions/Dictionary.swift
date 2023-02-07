//
//  Dictionary.swift
//  Food_Example
//
//  Created by Артур Кулик on 07.02.2023.
//

import Foundation

extension Dictionary where Key == String, Value == String {
    mutating func safely(key: String, value: String) {
        if !value.isEmpty {
            self[key] = value
        } else {
            self[key] = nil
        }
    }
}
