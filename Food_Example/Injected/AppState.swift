//
//  AppState.swift
//  Food_Example
//
//  Created by Артур Кулик on 20.01.2023.
//

import Foundation

struct AppState {
    static var stub: AppState {
        AppState(sessionService: SessionServiceImpl())
    }
    var user = UserInfo()
    var sessionService: SessionService
}
