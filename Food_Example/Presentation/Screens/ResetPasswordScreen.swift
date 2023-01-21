//
//  ResetPasswordScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 21.01.2023.
//

import FirebaseAuth
import SwiftUI

struct ResetPasswordScreen: View {
    let onClose: () -> Void
    @Environment(\.injected) var container: DIContainer
    @State var emailError: AuthErrorCode.Code = .keychainError
    @State var verificationError: VerificationError?
    @State var email = ""
    @State var showPopUp = false
    var body: some View {
        content
            .toolbar(.hidden)
    }
    
    private var content: some View {
        VStack(spacing: .zero) {
            navigationBar
            headerLabel
            descriptionTextView
            textField
            errorLabel
            resetPaswordButton
            Spacer()
        }
        .popup(isPresented: $showPopUp, overlayView: {
            CentralPopupView(isPresented: $showPopUp, title: "Password has been sended!") {
                VStack {
                    LottieView(name: Lottie.send, loopMode: .playOnce, speed: 2, isStopped: !showPopUp)
                        .frame(width: 120, height: 120)
                    Text("check your email for a link to the password change page")
                        .font(Fonts.makeFont(.medium, size: Constants.FontSizes.small))
                        .foregroundColor(Colors.dark)
                        .multilineTextAlignment(.center)
                }
            }
        })
    }
    
    private var navigationBar: some View {
        NavigationBarView()
            .addLeftContainer {
                Image(Images.icnArrowLeft)
                    .onTapGesture {
                        onClose()
                    }
            }
    }
    
    private var headerLabel: some View {
        HStack {
            Text("Reset Password")
                .modifier(LargeNavBarTextModifier())
            Spacer()
        }
        .padding(Constants.Spacing.s)
    }
    
    private var descriptionTextView: some View {
        HStack(spacing: .zero) {
            Text("Enter the email associated with your account and we'll send an email to reset your password")
                .font(Fonts.makeFont(.regular, size: Constants.FontSizes.small))
                .foregroundColor(Colors.gray)
                .padding(.leading, Constants.Spacing.s)
                .padding(.bottom, Constants.Spacing.s)
            Spacer(minLength: Constants.Spacing.xxl)
        }
    }
    
    var errorLabel: some View {
        errorText(error: emailError)
            .font(Fonts.makeFont(.medium, size: Constants.FontSizes.small))
            .foregroundColor(.red)
            .padding(Constants.Spacing.s)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var textField: some View {
        BorderedTextField(text: $email, verificationError: $verificationError, textFieldType: .email)
    }
    
    private var resetPaswordButton: some View {
        RoundedFilledButton(
            text: "Send Password",
            action: {
                container.interactors.authInteractor.resetPassword(to: email) { result in
                    switch result {
                    case .success:
                        showPopUp.toggle()
                    case .failure(let error):
                        emailError = error.code
                    }
                }
            }
        )
    }
}

struct ResetPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordScreen(onClose: {})
    }
}

extension ResetPasswordScreen {
    @ViewBuilder func errorText(error: AuthErrorCode.Code) -> some View {
        switch error {
        case .invalidEmail:
            self.verificationError = .email
            return Text("Invalid Email")
        case .missingEmail:
            self.verificationError = .email
            return Text("An email address must be provided")
        default:
            return Text(" ")
        }
    }
}

extension ResetPasswordScreen {
    func resetPasword(to: String, completion: @escaping () -> Void) {
    }
}
