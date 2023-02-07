//
//  IntContainsRange.swift
//  Food_Example
//
//  Created by Артур Кулик on 07.02.2023.
//

import Foundation

extension Int {
    func containsRange(min: Int, max: Int) -> Int {
        if self < min {
            return min
        } else if self > max {
            return max
        }
        return self
    }
}
