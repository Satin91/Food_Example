//
//  AuthErrorLabel.swift
//  Food_Example
//
//  Created by Артур Кулик on 23.01.2023.
//

import FirebaseAuth
import SwiftUI

struct AuthErrorLabel: View {
    let authError: AuthErrorCode.Code?
    
    var body: some View {
        errorLabel
    }
    
    private var errorLabel: some View {
        makeErrorText(error: authError)
            .font(Fonts.makeFont(.medium, size: Constants.FontSizes.small))
            .foregroundColor(.red)
            .padding(.vertical, Constants.Spacing.s)
            .padding(.horizontal, Constants.Spacing.s)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder func makeErrorText(error: AuthErrorCode.Code?) -> some View {
        switch error {
        case .invalidEmail:
            Text("Invalid Email")
        case .missingEmail:
            Text("Email must be provided")
        case .emailAlreadyInUse:
            Text("Email already in use")
        case .userNotFound:
            Text("User not found")
        case .weakPassword:
            Text("Password must contain at least 6 characters")
        case .wrongPassword:
            Text("Wrong Password")
        default:
            Text(" ")
        }
    }
}
