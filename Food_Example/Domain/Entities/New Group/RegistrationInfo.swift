//
//  RegistrationInfo.swift
//  Food_Example
//
//  Created by Артур Кулик on 19.01.2023.
//

import Foundation

struct RegistrationInfo {
    var name: String
    var email: String
    var password: String
}

extension RegistrationInfo {
    init() {
        self.name = ""
        self.email = ""
        self.password = ""
    }
}
