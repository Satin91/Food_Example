//
//  Application.swift
//  Food_Example
//
//  Created by Артур Кулик on 08.02.2023.
//

import SwiftUI

enum ApplicationUtility {
    static var rootViewController: UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
}
