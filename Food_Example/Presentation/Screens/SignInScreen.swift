//
//  SignInScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 17.01.2023.
//

import Combine
import FirebaseAuth
import SwiftUI

struct SignInScreen: View {
    @Environment(\.injected) var container: DIContainer
    @State var registrationInfo = RegistrationInfo()
    @State var authError: AuthErrorCode.Code = .keychainError
    @State var verificationError: VerificationError?
    let onMainScreen: () -> Void
    let onSignUpScreen: () -> Void
    let onResetPasswordScreen: () -> Void
    
    var body: some View {
        content
            .toolbar(.hidden)
    }
    
    private var content: some View {
        VStack(spacing: .zero) {
            navigationBarView
            textFieldContainer
            HStack {
                errorLabel
                Spacer()
                forgotPasswordButton
            }
            signInButton
            separatorContainer
            googleButton
            Spacer()
            bottomText
        }
    }
    
    var navigationBarView: some View {
        NavigationBarView()
            .addCentralContainer {
                Text("Sign In")
                    .font(Fonts.makeFont(.bold, size: Constants.FontSizes.large))
                    .foregroundColor(Colors.dark)
            }
    }
    
    var textFieldContainer: some View {
        VStack(spacing: Constants.Spacing.s) {
            BorderedTextField(text: $registrationInfo.email, verificationError: $verificationError, textFieldType: .email)
            BorderedTextField(text: $registrationInfo.password, verificationError: $verificationError, textFieldType: .password)
        }
        .padding(.top, Constants.Spacing.xl)
    }
    
    var errorLabel: some View {
        errorText(error: authError)
            .font(Fonts.makeFont(.medium, size: Constants.FontSizes.small))
            .foregroundColor(.red)
            .padding(.vertical, Constants.Spacing.s)
            .padding(.horizontal, Constants.Spacing.s)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var forgotPasswordButton: some View {
        Button(
            action: {
                onResetPasswordScreen()
            }
            , label: {
                Text("Forgot password ?")
                    .font(Fonts.makeFont(.medium, size: Constants.FontSizes.small))
                    .foregroundColor(Colors.dark)
                    .padding(.horizontal, Constants.Spacing.s)
            }
        )
    }
    
    private var signInButton: some View {
        RoundedFilledButton(text: "Sign In", action: {
            container.interactors.authInteractor.logIn(registrationInfo: registrationInfo) { result in
                switch result {
                case .success:
                    onMainScreen()
                case .failure(let error):
                    authError = error.code
                }
            }
        }
        )
    }
    
    private var separatorContainer: some View {
        HStack(spacing: Constants.Spacing.s) {
            separator
            Text("OR")
                .font(Fonts.makeFont(.regular, size: Constants.FontSizes.small))
                .foregroundColor(Colors.gray)
            separator
        }
        .padding(.horizontal, Constants.Spacing.s)
        .padding(.vertical, Constants.Spacing.m)
    }
    
    private var separator: some View {
        RoundedRectangle(cornerRadius: 1)
            .frame(height: 1)
            .foregroundColor(Colors.border)
    }
    
    private var googleButton: some View {
        GoogleButton {
            print("Sign UP!")
        }
    }
    
    private var bottomText: some View {
        HStack(spacing: Constants.Spacing.xxxs) {
            Text("Don’t have an account?")
                .font(Fonts.makeFont(.regular, size: Constants.FontSizes.small))
                .foregroundColor(Colors.dark)
            Text("Sign Up")
                .font(Fonts.makeFont(.bold, size: Constants.FontSizes.small))
                .foregroundColor(Colors.red)
                .onTapGesture {
                    onSignUpScreen()
                }
        }
        .padding(.bottom, Constants.Spacing.s)
    }
}

extension SignInScreen {
    @ViewBuilder func errorText(error: AuthErrorCode.Code) -> some View {
        switch error {
        case .invalidEmail:
            Text("Invalid Email")
        case .userNotFound:
            Text("Invalid Email")
        case .wrongPassword:
            Text("Wrong Password")
        default:
            Text(" ")
        }
    }
}
