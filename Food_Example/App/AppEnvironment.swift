//
//  AppEnvironment.swift
//  Food_Example
//
//  Created by Артур Кулик on 20.01.2023.
//

import Foundation

struct AppEnvironment {
    let appState: AppState
    let container: DIContainer
    
    static func bootstrap() -> AppEnvironment {
        let sessionService = SessionServiceImpl()
        let authRepository = AuthRepositoryImpl()
        let interactors = configureInteractors(authRepository: authRepository)
        let appState = configureAppState(sessionService: sessionService)
        let container = DIContainer(appState: appState, interactors: interactors)
        return AppEnvironment(appState: appState, container: container)
    }
    
    private static func configureAppState(sessionService: SessionService) -> AppState {
        AppState(sessionService: sessionService)
    }
    
    private static func configureInteractors(authRepository: AuthRepository) -> DIContainer.Interactors {
        .init(authInteractor: AuthInteractorImpl(authRepository: authRepository))
    }
}
