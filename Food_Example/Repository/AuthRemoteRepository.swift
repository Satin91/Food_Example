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
    func signUp(info: RegistrationInfo) -> AnyPublisher<FirebaseUserInfo, AuthErrorCode>
    func logIn(info: RegistrationInfo) -> AnyPublisher<UserInfo, AuthErrorCode>
    func resetPassword(to email: String) -> AnyPublisher<Void, AuthErrorCode>
    func signUpWithGoogle() -> Future<FirebaseUserInfo, GoogleSignUpError>
    func logout() -> Future<Void, Never>
}

class AuthRemoteRepositoryImpl: AuthRemoteRepository {
    var cancelBag = Set<AnyCancellable>()
    
    func logIn(info: RegistrationInfo) -> AnyPublisher<FirebaseUserInfo, AuthErrorCode> {
        Deferred {
            Future { promise in
                Auth.auth().signIn(withEmail: info.email, password: info.password) { result, error in
                    guard error == nil else {
                        promise(.failure(error as! AuthErrorCode))
                        return
                    }
                    guard let user = result?.user else {
                        fatalError("User not found")
                    }
                    promise(.success(user))
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    func signUp(info: RegistrationInfo) -> AnyPublisher<FirebaseUserInfo, AuthErrorCode> {
        Deferred {
            Future { promise in
                // Create user
                Auth.auth().createUser(withEmail: info.email, password: info.password) { result, error in
                    guard error == nil else { return promise(.failure(error as! AuthErrorCode)) }
                    guard var user = result?.user else {
                        promise(.failure(AuthErrorCode(.userMismatch)))
                        return }
                    user.setValue(info.username, forKey: "displayName")
                    promise(.success(user))
                }
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
    
    func signUpWithGoogle() -> Future<FirebaseUserInfo, GoogleSignUpError> {
        Future<FirebaseUserInfo, GoogleSignUpError> { promise in
            GIDSignIn.sharedInstance.signIn(withPresenting: ApplicationUtility.rootViewController) { result, error in
                guard error == nil else {
                    promise(.failure(.userCancel))
                    return
                }
                guard let profile = result?.user.profile else {
                    promise(.failure(.userError))
                    return
                }
                guard let user = result?.user else { return }
                let userInfo = RemoteUserInfo(uid: result?.user.userID ?? "ID", username: profile.name, email: profile.email, favoriteRecipesIDs: List<Int>())
            }
        }
    }
    
    func logout() -> Future<Void, Never> {
        Future<Void, Never> { promise in
            do {
                try Auth.auth().signOut()
                promise(.success(()))
            } catch {
                fatalError("Sudden error when User logging out")
            }
        }
    }
}
