//
//  AuthRepository.swift
//  Food_Example
//
//  Created by Артур Кулик on 19.01.2023.
//

import Combine
import FirebaseAuth
import FirebaseDatabase
import Foundation
import GoogleSignIn
import RealmSwift

protocol AuthRemoteRepository {
    func signUp(info: RegistrationInfo) -> AnyPublisher<RemoteUserInfo, AuthErrorCode>
    func logIn(info: RegistrationInfo) -> Future<RemoteUserInfo, AuthErrorCode>
    func resetPassword(to email: String) -> AnyPublisher<Void, AuthErrorCode>
    func signUpWithGoogle() -> Future<RemoteUserInfo, GoogleSignUpError>
    func logout() -> Future<Void, Never>
    func updateEmail(email: String) -> Future<Void, AuthErrorCode>
}

class AuthRemoteRepositoryImpl: AuthRemoteRepository {
    var cancelBag = Set<AnyCancellable>()
    
    func logIn(info: RegistrationInfo) -> Future<RemoteUserInfo, AuthErrorCode> {
        Future { promise in
            Auth.auth().signIn(withEmail: info.email, password: info.password) { result, error in
                guard error == nil else {
                    promise(.failure(error as! AuthErrorCode))
                    return
                }
                guard let user = result?.user else {
                    fatalError("User not found")
                }
                let userInfo = RemoteUserInfo(uid: user.uid, username: info.username, email: info.email)
                promise(.success(userInfo))
            }
        }
    }
    
    func signUp(info: RegistrationInfo) -> AnyPublisher<RemoteUserInfo, AuthErrorCode> {
        Future { promise in
            // Create user
            Auth.auth().createUser(withEmail: info.email, password: info.password) { result, error in
                guard error == nil else { return promise(.failure(error as! AuthErrorCode)) }
                guard let user = result?.user else {
                    promise(.failure(AuthErrorCode(.userMismatch)))
                    return }
                let userInfo = RemoteUserInfo(uid: user.uid, username: info.username, email: info.email)
                promise(.success(userInfo))
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    func resetPassword(to email: String) -> AnyPublisher<Void, AuthErrorCode> {
        Deferred {
            Future { promise in
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if error != nil {
                        guard let error = error as? AuthErrorCode else { return }
                        promise(.failure(error))
                    } else {
                        promise(.success(Void()))
                    }
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    func signUpWithGoogle() -> Future<RemoteUserInfo, GoogleSignUpError> {
        Future<RemoteUserInfo, GoogleSignUpError> { promise in
            GIDSignIn.sharedInstance.signIn(withPresenting: ApplicationUtility.rootViewController) { result, error in
                guard error == nil else {
                    promise(.failure(.userCancel))
                    return
                }
                guard let profile = result?.user.profile else {
                    promise(.failure(.userError))
                    return
                }
                let userInfo = RemoteUserInfo(uid: result?.user.userID ?? "ID", username: profile.name, email: profile.email, favoriteRecipesIDs: [0])
                promise(.success(userInfo))
            }
        }
    }
    
    func updateEmail(email: String) -> Future<Void, AuthErrorCode> {
        Future { promise in
            Auth.auth().currentUser?.updateEmail(to: email) { error in
                if error == nil {
                    promise(.success(()))
                } else {
                    promise(.failure(error as! AuthErrorCode))
                }
            }
        }
    }
    
    func logout() -> Future<Void, Never> {
        Future<Void, Never> { promise in
            do {
                try
                Auth.auth().signOut()
                GIDSignIn.sharedInstance.signOut()
                promise(.success(()))
            } catch {
                fatalError("Sudden error when User logging out")
            }
        }
    }
}
