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

protocol AuthWebRepository {
    func signUp(info: RegistrationInfo) -> AnyPublisher<Void, AuthErrorCode>
    func logIn(registrationInfo: RegistrationInfo) -> AnyPublisher<RemoteUserInfo, AuthErrorCode>
    func resetPassword(to email: String) -> AnyPublisher<Void, AuthErrorCode>
    func signUpWithGoogle() -> Future<RemoteUserInfo, GoogleSignUpError>
    func logout() -> Future<Void, Never>
}

struct UserInfoConfig {
    let email = "email"
    let username = "username"
    let favoriteRecipes = "favoriteRecipes"
}

class AuthWebRepositoryImpl: AuthWebRepository {
    let userInfoConfig = UserInfoConfig()
    var cancelBag = Set<AnyCancellable>()
    
    func logIn(registrationInfo: RegistrationInfo) -> AnyPublisher<RemoteUserInfo, AuthErrorCode> {
        Deferred {
            Future { promise in
                Auth.auth().signIn(withEmail: registrationInfo.email, password: registrationInfo.password) { user, error in
                    if error != nil {
                        promise(.failure(error as! AuthErrorCode))
                    } else {
                        guard let uid = user?.user.uid else { return }
                        self.getUserFromDatabase(uid: uid)
                            .sink { userInfo in
                                promise(.success(userInfo))
                            }
                            .store(in: &self.cancelBag)
                    }
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    func signUp(info: RegistrationInfo) -> AnyPublisher<Void, AuthErrorCode> {
        Deferred {
            Future { promise in
                // Create user
                Auth.auth().createUser(withEmail: info.email, password: info.password) { result, error in
                    guard error == nil else { return promise(.failure(error as! AuthErrorCode)) }
                    guard let uid = result?.user.uid else { return promise(.failure(AuthErrorCode(.userMismatch))) }
                    let values: [String: Any] = [
                        "username": info.username,
                        "email": info.email,
                        "favoriteRecipes": Array([""])
                    ]
                    // Upload registration data to remote database
                    if let user = result?.user {
                        user.sendEmailVerification()
                    }
                    
                    Database.userReferenceFrom(uid: uid)
                        .updateChildValues(values) { error, _ in
                            if let error {
                                promise(.failure(error as! AuthErrorCode))
                            } else {
                                promise(.success(()))
                            }
                        }
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
                let userInfo = RemoteUserInfo(uid: result?.user.userID ?? "ID", username: profile.name, email: profile.email, favoriteRecipesIDs: [])
                promise(.success(userInfo))
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
    
    private func createUserInDatabase(uid: String) {
    }
}

extension AuthWebRepositoryImpl {
    private func getUserFromDatabase(uid: String) -> Future<RemoteUserInfo, Never> {
        Future { promise in
            Database.userReferenceFrom(uid: uid).getData(completion: { [weak self] error, snapshot in
                guard let self else { return }
                guard error == nil else { return }
                guard let value = snapshot?.value as? [String: Any] else { return }
                let user = RemoteUserInfo()
                user.uid = uid
                user.email = (value[self.userInfoConfig.email] as! String).lowercased()
                user.username = value[self.userInfoConfig.username] as! String
                user.favoriteRecipesIDs = value[self.userInfoConfig.favoriteRecipes] as! [Int]
                promise(.success(user))
            })
        }
    }
}
