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
        let sessionService = SessionServiceImpl()
        let appState = configureAppState(sessionService: sessionService)
        let interactors = configureInteractors(appstate: appState)
        let container = DIContainer(appState: appState, interactors: interactors)
        return AppEnvironment(appState: appState, container: container)
    }
    
    private static func configureAppState(sessionService: SessionService) -> Store<AppState> {
        Store<AppState>(AppState())
    }
    
    private static func configureInteractors(appstate: Store<AppState>) -> DIContainer.Interactors {
        .init(
            authInteractor: AuthInteractorImpl(authRepository: AuthWebRepositoryImpl(), appState: appstate),
            recipesInteractor: RecipesInteractorImpl(recipesWebRepository: RecipesWebRepositoryImpl(), recipesDBRepository: RecipesDBRepositoryImpl(), appState: appstate)
        )
    }
}
