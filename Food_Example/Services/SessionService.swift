//
//  SessionService.swift
//  Food_Example
//
//  Created by Артур Кулик on 19.01.2023.
//

import Combine
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import GoogleSignIn
import SwiftUI

enum SessionState {
    case loggedIn(RemoteUserInfo)
    case loggedOut
}

protocol SessionService {
    var state: SessionState { get }
}

final class SessionServiceImpl: ObservableObject, SessionService {
    @Published var state: SessionState = .loggedOut
    private var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        setupFirebaseAuthHandler()
        signUpWithGoogle()
    }
    
    private func setupFirebaseAuthHandler() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self else { return }
            self.state = user == nil ? .loggedOut : .loggedIn(
                RemoteUserInfo(
                    uid: user?.uid ?? "ID",
                    username: user?.displayName ?? "No user name",
                    email: user?.email ?? "No email"
                )
            )
        }
    }
    
    //    private func handleRefresh(email: String) {
    //        Database.userReferenceFrom(uid: email)
    //            .observe(.value) { [weak self] snapshot in
    //                guard
    //                    let self = self,
    //                    let value = snapshot.value as? NSDictionary,
    //                    let username = value["username"] as? String,
    //                    let email = value["email"] as? String else {
    //                    return
    //                }
    //
    //                DispatchQueue.main.async {
    //                    self.userInfo = UserInfo(
    //                        username: username,
    //                        email: email,
    //                        recipes: []
    //                    )
    //                }
    //            }
    //    }
    
    private func signUpWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
    }
}

extension Database {
    static func userReferenceFrom(uid: String) -> DatabaseReference {
        self.database().reference().child("users").child(uid)
    }
}
