//
//  MainViewModel.swift
//  Food_Example
//
//  Created by Артур Кулик on 11.01.2023.
//

import SwiftUI

final class MainViewModel: ObservableObject {
    @Published var recipes: [Results] = []
    private let networkingManager = NetworkManager()
    
    init() {
        Task {
            try await getRecipes()
        }
    }
    
    private func getRecipes() async throws {
        let recipes = try await networkingManager.getResult()
        DispatchQueue.main.async {
            self.recipes = recipes
            print(recipes)
        }
    }
}
