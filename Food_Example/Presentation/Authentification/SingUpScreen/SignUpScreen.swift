//
//  SignUpScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 14.01.2023.
//

import SwiftUI

struct SignUpScreen: View {
    @State var username = ""
    @State var email = ""
    @State var password = ""
    let onMainScreen: () -> Void
    let onClose: () -> Void
    
    @ObservedObject var viewModel = SignUpViewModel()
    
    var body: some View {
        content
            .toolbar(.hidden)
    }
    
    private var content: some View {
        VStack(spacing: Constants.Spacing.zero) {
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
                Image(Images.icnArrowRight)
                    .onTapGesture {
                        onClose()
                    }
            }
            .addCentralContainer {
                Text("Create an Account")
                    .font(Fonts.custom(.bold, size: Constants.FontSizes.large))
                    .foregroundColor(Colors.dark)
            }
    }
    
    var textFieldContainer: some View {
        VStack(spacing: Constants.Spacing.s) {
            BorderedTextField(text: $username, textFieldType: .userName)
            BorderedTextField(text: $email, textFieldType: .email)
            BorderedTextField(text: $password, textFieldType: .password)
        }
        .padding(.top, Constants.Spacing.xl)
    }
    
    private var signUpButton: some View {
        RoundedFilledButton(text: "Sign Up", action: {
            viewModel.signUpWithEmail(
                email: email,
                password: password,
                completion: { success in
                    if success {
                        self.onMainScreen()
                    } else {
                        onMainScreen()
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

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen(
            onMainScreen: {},
            onClose: {}
        )
    }
}
