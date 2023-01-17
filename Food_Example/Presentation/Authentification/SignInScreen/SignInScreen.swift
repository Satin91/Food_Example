//
//  SignInScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 17.01.2023.
//

import SwiftUI

struct SignInScreen: View {
    @State var email = ""
    @State var password = ""
    @ObservedObject var viewModel = SignInViewModel()
    let onMainScreen: () -> Void
    let onSignUpScreen: () -> Void
    
    var body: some View {
        content
            .toolbar(.hidden)
    }
    
    private var content: some View {
        VStack(spacing: Constants.Spacing.zero) {
            navigationBarView
            textFieldContainer
            signInButton
            separatorContainer
            googleButton
            Spacer()
        }
    }
    
    var navigationBarView: some View {
        NavigationBarView()
            .addCentralContainer {
                Text("Sign In")
                    .font(Fonts.custom(.bold, size: Constants.FontSizes.large))
                    .foregroundColor(Colors.dark)
            }
    }
    
    var textFieldContainer: some View {
        VStack(spacing: Constants.Spacing.s) {
            BorderedTextField(text: $email, textFieldType: .email)
            BorderedTextField(text: $password, textFieldType: .password)
        }
        .padding(.top, Constants.Spacing.xl)
    }
    
    private var signInButton: some View {
        RoundedFilledButton(text: "Sign In", action: {
            viewModel.signIn(
                email: email,
                password: password,
                completionHandler: { result in
                    switch result {
                    case .none:
                        print("Error")
                    case .some(let wrapped):
                        print(wrapped.user.uid)
                        self.onMainScreen()
                    }
                }
            )
        }
        )
        .padding(.top, Constants.Spacing.m)
    }
    
    private var separatorContainer: some View {
        HStack(spacing: Constants.Spacing.s) {
            separator
            Text("OR")
                .font(Fonts.custom(.regular, size: Constants.FontSizes.small))
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

struct SignInScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignInScreen(
            onMainScreen: {},
            onSignUpScreen: {}
        )
    }
}
