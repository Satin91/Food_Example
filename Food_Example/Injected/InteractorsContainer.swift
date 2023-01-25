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
        let imageInteractor: ImageInteractor
        
        init(authInteractor: AuthInteractor, recipesInteractor: RecipesInteractor, imageInteractor: ImageInteractor) {
            self.authInteractor = authInteractor
            self.recipesInteractor = recipesInteractor
            self.imageInteractor = imageInteractor
        }
        
        static var stub: Self {
            .init(
                authInteractor: StubAuthInteractor(),
                recipesInteractor: StubRecipesInteractor(),
                imageInteractor: StubImageInteractor()
            )
        }
    }
}
