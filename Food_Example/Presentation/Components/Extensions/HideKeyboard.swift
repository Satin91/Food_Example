//
//  HideKeyboard.swift
//  Food_Example
//
//  Created by Артур Кулик on 14.01.2023.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
