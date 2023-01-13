//
//  Theme.swift
//  Food_Example
//
//  Created by Артур Кулик on 12.01.2023.
//

import Foundation

enum Constants {
    enum FontSizes {
        static let minimum: CGFloat = 12
        static let small: CGFloat = 14
        static let medium: CGFloat = 16
        static let upperMedium: CGFloat = 18
        static let large: CGFloat = 24
        static let upperLarge: CGFloat = 40
    }
    
    enum Spacing {
        static let zero: CGFloat = 0
        static let xxxxs: CGFloat = 2
        static let xxxs: CGFloat = 4
        static let xxs: CGFloat = 8
        static let xs: CGFloat = 12
        static let s: CGFloat = 16
        static let m: CGFloat = 24
        static let l: CGFloat = 32
        static let xl: CGFloat = 44
        static let xxl: CGFloat = 64
        static let xxxl: CGFloat = 88
    }
    
    enum ButtonWidth {
        static let small: CGFloat = 84
        static let medium: CGFloat = 190
        static let large: CGFloat = 327
    }
}

enum Images {
    static let icnBurger = "icnBurger"
    static let icnCoffee = "icnCoffee"
    static let icnDorayaki = "icnDorayaki"
    static let icnFrenchFries = "icnFrenchFries"
    static let icnFrenchFriesRed = "icnFrenchFriesRed"
    static let icnHotDog = "icnHotDog"
    static let icnIceCream = "icnIceCream"
    static let icnKebab = "icnKebab"
    static let icnMilk = "icnMilk"
    static let icnMuffin = "icnMuffin"
    static let icnPizza = "icnPizza"
    static let icnSandwich = "icnSandwich"
    static let icnTacos = "icnTacos"
    static let foodBackground = "foodBackground"
    
    static let icnArrowLeft = "icnArrowLeft"
    static let icnArrowRight = "icnArrowRight"
}

enum Colors {
    static let backgroundWhite = "backgroundWhite"
    static let black = "black"
    static let dark = "dark"
    static let gray = "gray"
    static let green = "green"
    static let lightGray = "lightGray"
    static let weakDark = "weakDark"
    static let weakGray = "weakGray"
    static let yellow = "yellow"
    static let placeholder = "placeholder"
}
