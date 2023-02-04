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
    let animationViewSize: CGFloat = 120
    
    @Environment(\.injected) var container: DIContainer
    @State var emailError: AuthErrorCode.Code?
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
        .popup(isPresented: $showPopUp, type: .center, overlayView: {
            CentralPopupView(isPresented: $showPopUp, title: "Password has been sended!") {
                VStack {
                    LottieView(name: Lottie.send, loopMode: .playOnce, speed: 1.8, isStopped: !showPopUp)
                        .frame(width: animationViewSize, height: animationViewSize)
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
        AuthErrorLabel(authError: emailError)
    }
    
    private var textField: some View {
        BorderedTextField(text: $email, verificationError: $emailError, textFieldType: .email)
    }
    
    private var resetPaswordButton: some View {
        RoundedFilledButton(
            text: "Send Password",
            action: {
                container.interactors.authInteractor.resetPassword(to: email) { result in
                    switch result {
                    case .success:
                        showPopUp.toggle()
                        emailError = nil
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
