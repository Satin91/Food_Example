//
//  SignUpScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 14.01.2023.
//

import SwiftUI

struct SignUpScreen: View {
    @State var usernameText: String = ""
    @State var emailText: String = ""
    @State var passwordText: String = ""
    
    var body: some View {
        content
            .onTapGesture {
                hideKeyboard()
            }
            .toolbar(.hidden)
    }
    
    private var content: some View {
        VStack(spacing: Constants.Spacing.zero) {
            navigationBarView
            textFieldContainer
            filledButton
            separatorContainer
            googleButton
            Spacer()
        }
    }
    
    var navigationBarView: some View {
        NavigationBarView()
            .addCentralContainer {
                Text("Create an Account")
                    .font(Fonts.custom(.bold, size: Constants.FontSizes.large))
                    .foregroundColor(Colors.dark)
            }
    }
    
    var textFieldContainer: some View {
        VStack(spacing: Constants.Spacing.s) {
            BorderedTextField(text: $usernameText, textFieldType: .userName)
            BorderedTextField(text: $emailText, textFieldType: .email)
            BorderedTextField(text: $passwordText, textFieldType: .password)
        }
        .padding(.top, Constants.Spacing.xl)
    }
    
    private var filledButton: some View {
        RoundedFilledButton(text: "Sign Up", action: {
            print("Tapped")
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
        SignUpScreen()
    }
}
