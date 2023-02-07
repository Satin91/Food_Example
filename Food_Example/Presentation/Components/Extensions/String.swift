//
//  String.swift
//  Food_Example
//
//  Created by Артур Кулик on 07.02.2023.
//

import Foundation

extension String {
    func containsRange(min: Int, max: Int) -> String {
        guard let numValue = Int(self) else { return self }
        if numValue < min {
            return String(min)
        } else if numValue > max {
            return String(max)
        }
        return String(numValue)
    }
}
