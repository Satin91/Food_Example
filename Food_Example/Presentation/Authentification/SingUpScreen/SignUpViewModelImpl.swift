//
//  SignUpViewModel.swift
//  Food_Example
//
//  Created by Артур Кулик on 16.01.2023.
//

import Combine
import FirebaseAuth
import SwiftUI

enum RegistrationState: Error {
    case success
    case failure(Error)
    case unknown
}

protocol SignUpViewModel {
    var repo: RegistrationRepository { get }
    var authDetails: RegistrationInfo { get }
    var state: RegistrationState { get }
    
    init(repo: RegistrationRepository)
    
    func register()
}

final class SignUpViewModelImpl: ObservableObject, SignUpViewModel {
    var repo: RegistrationRepository
    var authDetails = RegistrationInfo()
    var state: RegistrationState = .unknown
    private var subscription = Set<AnyCancellable>()
    
    init(repo: RegistrationRepository) {
        self.repo = repo
    }
    
    func register() {
        repo.register(details: authDetails)
            .sink { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.state = .failure(error)
                default:
                    break
                }
            } receiveValue: { [weak self] in
                self?.state = .success
            }
            .store(in: &subscription)
    }
}
