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
    @State var error: AuthErrorCode.Code = .keychainError
    @State var verificationError: VerificationError?
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
            signUpButton
            separatorContainer
            googleButton
            Spacer()
        }
    }
    
    var navigationBarView: some View {
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
    
    var textFieldContainer: some View {
        VStack(spacing: Constants.Spacing.s) {
            BorderedTextField(text: $registrationInfo.name, verificationError: $verificationError, textFieldType: .userName)
            BorderedTextField(text: $registrationInfo.email, verificationError: $verificationError, textFieldType: .email)
            BorderedTextField(text: $registrationInfo.password, verificationError: $verificationError, textFieldType: .password)
        }
        .padding(.top, Constants.Spacing.xl)
    }
    
    private var signUpButton: some View {
        RoundedFilledButton(
            text: "Sign Up", action: {
                container.interactors.authInteractor.signUp(registrationInfo: registrationInfo) { result in
                    print("RESULT \(result)")
                    switch result {
                    case .success:
                        onMainScreen()
                    case .failure:
                        print("Registration failed")
                    }
                }
            }
        )
        .padding(.top, Constants.Spacing.m)
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
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen(
            error: .keychainError,
            onMainScreen: {},
            onClose: {}
        )
    }
}
