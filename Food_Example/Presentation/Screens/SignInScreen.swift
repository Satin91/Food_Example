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
    @State var authError: AuthErrorCode.Code?
    let onMainScreen: () -> Void
    let onSignUpScreen: () -> Void
    let onResetPasswordScreen: () -> Void
    
    var body: some View {
        content
            .toolbar(.hidden)
            .onAppear {
                getRecipes()
            }
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
            BorderedTextField(text: $registrationInfo.email, verificationError: $authError, textFieldType: .email)
            BorderedTextField(text: $registrationInfo.password, verificationError: $authError, textFieldType: .password)
        }
        .padding(.top, Constants.Spacing.xl)
    }
    
    var errorLabel: some View {
        AuthErrorLabel(authError: authError)
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
            getRecipes()
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
    
    func getRecipes() {
        do {
            try NetworkServiceImpl(session: URLSession(), baseURL: "https://api.spoonacular.com/recipes/complexSearch", queue: DispatchQueue.main).searchRecipes(model: SearchRecipesWrapper.self, params: ComplexSearchParams(query: "", includeIngridients: "", number: 5, maxFat: 15))
        } catch let error {
            print(error)
        }
    }
}

struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        SignInScreen(
            onMainScreen: {},
            onSignUpScreen: {},
            onResetPasswordScreen: {}
        )
    }
}