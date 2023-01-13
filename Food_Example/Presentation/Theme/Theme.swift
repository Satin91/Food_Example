//
//  Theme.swift
//  Food_Example
//
//  Created by Артур Кулик on 12.01.2023.
//

import SwiftUI

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
    
    enum ButtonHeight {
        static let small: CGFloat = 30
        static let medium: CGFloat = 48
        static let large: CGFloat = 56
    }
    
    static let cornerRadius: CGFloat = 16
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
    static let icnEye = "icnEye"
    static let icnEyeOff = "icnEyeOff"
    static let icnHome = "icnHome"
    static let icnLock = "icnLock"
    static let icnMenu = "icnMenu"
    static let icnMessage = "icnMessage"
    static let icnSearch = "icnSearch"
    static let icnUser = "icnUser"
    
    static let icnGoogle = "icnGoogle"
}

enum Colors {
    static let backgroundWhite = Color("backgroundWhite")
    static let black = Color("black")
    static let dark = Color("dark")
    static let gray = Color("gray")
    static let green = Color("green")
    static let red = Color("red")
    static let lightGray = Color("lightGray")
    static let weakDark = Color("weakDark")
    static let weakGray = Color("weakGray")
    static let yellow = Color("yellow")
    static let placeholder = Color("placeholder")
    static let border = Color("border")
}
