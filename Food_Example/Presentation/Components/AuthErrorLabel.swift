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
        case .networkError:
            Text("Network Error")
        default:
            Text(" ")
        }
    }
}

extension AuthErrorCode.Code {
    var description: String {
        switch self {
        case .invalidEmail:
            return "Invalid Email"
        case .missingEmail:
            return "Email must be provided"
        case .emailAlreadyInUse:
            return "Email already in use"
        case .userNotFound:
            return "User not found"
        case .weakPassword:
            return "Password must contain at least 6 characters"
        case .wrongPassword:
            return "Wrong Password"
        case .networkError:
            return "Network Error"
        case .emailChangeNeedsVerification:
            return "Need to reauthorize"
        case .requiresRecentLogin:
            return "Need reautorize to change email"
        case .invalidRecipientEmail:
            return "Recipient email"
        case .unverifiedEmail:
            return "Unverified email"
        default:
            return "None"
        }
    }
}
