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
        
        init(authInteractor: AuthInteractor) {
            self.authInteractor = authInteractor
        }
        
        static var stub: Self {
            .init(authInteractor: StubAuthInteractor())
        }
    }
}
