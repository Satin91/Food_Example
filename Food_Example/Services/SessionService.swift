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

final class SessionService: ObservableObject {
    @Published var state: SessionState = .loggedOut
    private var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        googleConfiguration()
        authHandler()
    }
    
    private func authHandler() {
        restoreFirebaseSignIn()
        restoreGoogleSignIn()
    }
    
    private func restoreFirebaseSignIn() {
        handle = Auth.auth().addStateDidChangeListener { _, user in
            guard let user else { return }
            print("Firebase auth sing in \(String(describing: user.email))")
            let userInfo = RemoteUserInfo()
            userInfo.uid = user.uid
            userInfo.username = user.displayName ?? "No user name"
            userInfo.email = user.email ?? "No email"
            self.state = .loggedIn(userInfo)
        }
    }
    
    private func restoreGoogleSignIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, _ in
            guard let user else { return }
            print("Goolge auth sing in \(String(describing: user.profile?.email))")
            let userInfo = RemoteUserInfo()
            userInfo.uid = user.userID ?? "ID"
            userInfo.username = user.profile?.name ?? "No user name"
            userInfo.email = user.profile?.email ?? "No email"
            self.state = .loggedIn(userInfo)
        }
    }
    
    private func googleConfiguration() {
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
