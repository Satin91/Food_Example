//
//  SignUpScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 14.01.2023.
//

import FirebaseAuth
import SwiftUI

struct SignUpScreen: View {
    @Environment(\.injected) var container: DIContainer
    @State var registrationInfo = RegistrationInfo()
    @State var authError: AuthErrorCode.Code?
    let onMainScreen: () -> Void
    let onClose: () -> Void
    
    var body: some View {
        content
            .toolbar(.hidden)
    }
    
    private var content: some View {
        VStack(spacing: .zero) {
            navigationBarView
            textFieldContainer
            errorLabel
            signUpButton
            separatorContainer
            googleButton
            Spacer()
        }
    }
    
    private var navigationBarView: some View {
        NavigationBarView()
            .addLeftContainer {
                Image(Images.icnArrowLeft)
                    .onTapGesture {
                        onClose()
                    }
            }
            .addCentralContainer {
                Text("Create an Account")
                    .font(Fonts.makeFont(.bold, size: Constants.FontSizes.large))
                    .foregroundColor(Colors.dark)
            }
    }
    
    private var textFieldContainer: some View {
        VStack(spacing: Constants.Spacing.s) {
            BorderedTextField(text: $registrationInfo.name, verificationError: $authError, textFieldType: .userName)
            BorderedTextField(text: $registrationInfo.email, verificationError: $authError, textFieldType: .email)
            BorderedTextField(text: $registrationInfo.password, verificationError: $authError, textFieldType: .password)
        }
        .padding(.top, Constants.Spacing.xl)
    }
    
    private var errorLabel: some View {
        AuthErrorLabel(authError: authError)
    }
    
    private var signUpButton: some View {
        RoundedFilledButton(
            text: "Sign Up", action: {
                container.interactors.authInteractor.signUp(registrationInfo: registrationInfo) { result in
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
            .foregroundColor(Colors.neutralGray)
    }
    
    private var googleButton: some View {
        GoogleButton {
            print("Sign UP!")
        }
    }
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen(
            authError: .keychainError,
            onMainScreen: {},
            onClose: {}
        )
    }
}
