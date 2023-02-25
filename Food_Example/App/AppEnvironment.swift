//
//  AppEnvironment.swift
//  Food_Example
//
//  Created by Артур Кулик on 20.01.2023.
//

import Combine
import Foundation
import RealmSwift

struct AppEnvironment {
    let appState: Store<AppState>
    let container: DIContainer
    
    static func bootstrap() -> AppEnvironment {
        let appState = configureAppState()
        let interactors = configureInteractors(
            storageRepository: StorageRepositoryImpl(),
            authRepository: AuthWebRepositoryImpl(),
            appstate: appState
        )
        let container = DIContainer(appState: appState, interactors: interactors)
        return AppEnvironment(appState: appState, container: container)
    }
    
    private static func configureAppState() -> Store<AppState> {
        Store<AppState>(AppState())
    }
    
    private static func configureInteractors(storageRepository: StorageRepository, authRepository: AuthWebRepository, appstate: Store<AppState>) -> DIContainer.Interactors {
        .init(
            authInteractor: AuthInteractorImpl(authRepository: authRepository, dbRepository: storageRepository, appState: appstate),
            recipesInteractor: RecipesInteractorImpl(recipesApiRepository: RecipesApiRepositoryImpl(), storageRepository: storageRepository, appState: appstate),
            userInteractor: UserInteractorImpl(dbRepository: storageRepository, authRepository: authRepository, appState: appstate)
        )
    }
}
