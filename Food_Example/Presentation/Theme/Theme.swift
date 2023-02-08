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
        static let extraMedium: CGFloat = 18
        static let large: CGFloat = 24
        static let extraLarge: CGFloat = 40
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
    enum API {
        // first key a053c68935284fc0b0041026bf79c509
        // secondary key 67dbadc95b2244a2964aae01c89b3277
        // third key 4d80c10b5be14b9481d8968644d75999
        static let apiKey = "a053c68935284fc0b0041026bf79c509"
        static let baseURL = "https://api.spoonacular.com/recipes/"
        static let baseIngredientImageURL = "https://spoonacular.com/cdn/ingredients_100x100/"
    }
    
    static let loaderLottieSize: CGFloat = 120
    static let smallCornerRadius: CGFloat = 8
    static let cornerRadius: CGFloat = 16
}

enum Images {
    static let imgBurger = "imgBurger"
    static let imgCoffee = "imgCoffee"
    static let imgDorayaki = "imgDorayaki"
    static let imgFrenchFries = "imgFrenchFries"
    static let imgFrenchFriesRed = "imgFrenchFriesRed"
    static let imgHotDog = "imgHotDog"
    static let imgIceCream = "imgIceCream"
    static let imgKebab = "imgKebab"
    static let imgMilk = "imgMilk"
    static let imgMuffin = "imgMuffin"
    static let imgPizza = "imgPizza"
    static let imgSandwich = "imgSandwich"
    static let imgTacos = "imgTacos"
    static let foodBackground = "foodBackground"
    static let mockFood = "mockFood"
    
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
    static let icnSettingsVertical = "icnSettingsVertical"
    static let icnChevronLeft = "icnChevronLeft"
    static let icnChevronRight = "icnChevronRight"
    static let icnClock = "icnClock"
    static let icnFilter = "icnFilter"
    static let icnClose = "icnClose"
    
    static let icnFats = "icnFats"
    static let icnProtein = "icnProtein"
    static let icnCarbs = "icnCarbs"
    static let icnKcal = "icnKcal"
    
    static let icnGoogle = "icnGoogle"
    
    static let icnHomeFilled = "icnHomeFilled"
    static let icnSearchFilled = "icnSearchFilled"
    static let icnUserFilled = "icnUserFilled"
}

enum Lottie {
    static let loader = "Loader"
    static let send = "Send"
}

enum Colors {
    static let backgroundWhite = Color("backgroundWhite")
    static let black = Color("black")
    static let dark = Color("dark")
    static let gray = Color("gray")
    static let green = Color("green")
    static let red = Color("red")
    static let silver = Color("silver")
    static let weakDark = Color("weakDark")
    static let weakGray = Color("weakGray")
    static let yellow = Color("yellow")
    static let placeholder = Color("placeholder")
    static let neutralGray = Color("neutralGray")
    static let blue = Color("blue")
}
