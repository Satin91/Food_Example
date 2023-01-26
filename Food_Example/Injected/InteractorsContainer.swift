//
//  InteractorsContainer.swift
//  Food_Example
//
//  Created by Артур Кулик on 20.01.2023.
//

import Foundation

extension DIContainer {
    struct Interactors {
        let authInteractor: AuthInteractor
        let recipesInteractor: RecipesInteractor
        
        init(authInteractor: AuthInteractor, recipesInteractor: RecipesInteractor) {
            self.authInteractor = authInteractor
            self.recipesInteractor = recipesInteractor
        }
        
        static var stub: Self {
            .init(
                authInteractor: StubAuthInteractor(),
                recipesInteractor: StubRecipesInteractor()
            )
        }
    }
}
