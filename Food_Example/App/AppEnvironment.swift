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
        let interactors = configureInteractors(dbRepository: DBRepositoryImpl(), appstate: appState)
        let container = DIContainer(appState: appState, interactors: interactors)
        return AppEnvironment(appState: appState, container: container)
    }
    
    private static func configureAppState() -> Store<AppState> {
        Store<AppState>(AppState())
    }
    
    private static func configureInteractors(dbRepository: DBRepository, appstate: Store<AppState>) -> DIContainer.Interactors {
        .init(
            authInteractor: AuthInteractorImpl(authRepository: AuthWebRepositoryImpl(), dbRepository: dbRepository, appState: appstate),
            recipesInteractor: RecipesInteractorImpl(recipesWebRepository: RecipesWebRepositoryImpl(), dbRepository: dbRepository, appState: appstate),
            userInteractor: UserInteractorImpl(dbRepository: dbRepository, appState: appstate)
        )
    }
}
