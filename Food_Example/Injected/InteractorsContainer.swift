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
        let userInteractor: UserInteractor
        
        init(authInteractor: AuthInteractor, recipesInteractor: RecipesInteractor, userInteractor: UserInteractor) {
            self.authInteractor = authInteractor
            self.recipesInteractor = recipesInteractor
            self.userInteractor = userInteractor
        }
        
        static var stub: Self {
            .init(
                authInteractor: StubAuthInteractor(),
                recipesInteractor: StubRecipesInteractor(),
                userInteractor: StubUserInteractor()
            )
        }
    }
}
