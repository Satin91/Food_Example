//
//  DependencyInjection.swift
//  Food_Example
//
//  Created by Артур Кулик on 20.01.2023.
//

import SwiftUI

struct DIContainer: EnvironmentKey {
    static var defaultValue: Self { Self.default }
    private static let `default` = Self(appState: .stub, interactors: .stub)
    
    let appState: AppState
    let interactors: Interactors
    
    init(appState: AppState, interactors: Interactors) {
        self.appState = appState
        self.interactors = interactors
    }
}

extension EnvironmentValues {
    var injected: DIContainer {
        get { self[DIContainer.self] }
        set { self[DIContainer.self] = newValue }
    }
}

extension View {
    func inject(_ container: DIContainer) -> some View {
        self.environment(\.injected, container)
    }
}
