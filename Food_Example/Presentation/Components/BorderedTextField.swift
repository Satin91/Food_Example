//
//  BorderedTextField.swift
//  Food_Example
//
//  Created by Артур Кулик on 13.01.2023.
//

import FirebaseAuth
import SwiftUI

struct BorderedTextField: View {
    enum TextFieldType {
        case email
        case password
        case userName
    }
    
    @Binding var text: String
    @Binding var verificationError: AuthErrorCode.Code?
    @State var isPasswordHidden = true
    let viewHeight: CGFloat = 56
    
    var borderColor: Color {
        switch verificationError {
        case .userNotFound, .missingEmail, .invalidEmail, .emailAlreadyInUse:
            return textFieldType == .email ? Colors.red : Colors.neutralGray
        case .weakPassword, .wrongPassword:
            return textFieldType == .password ? Colors.red : Colors.neutralGray
        default:
            return Colors.neutralGray
        }
    }
    
    let textFieldType: TextFieldType
    let borderWidth: CGFloat = 1
    
    var title: String {
        switch textFieldType {
        case .userName:
            return "Username"
        case .email:
            return "Email address"
        case .password:
            return "Password"
        }
    }
    
    var placeholderText: String {
        switch textFieldType {
        case .userName:
            return "Enter your name"
        case .email:
            return "Myemail@mail.com"
        case .password:
            return "At least 6 characters"
        }
    }
    
    var leftImageName: String {
        switch textFieldType {
        case .userName:
            return Images.icnUser
        case .email:
            return Images.icnMessage
        case .password:
            return Images.icnLock
        }
    }
    
    var body: some View {
        content
    }
    
    var content: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.xxs) {
            titleView
            borderedTextFieldView
                .frame(height: viewHeight)
        }
        .padding(.horizontal, Constants.Spacing.s)
    }
    
    var titleView: some View {
        Text(title)
            .font(Fonts.makeFont(.medium, size: Constants.FontSizes.small))
            .foregroundColor(Colors.gray)
    }
    
    var borderedTextFieldView: some View {
        HStack {
            leftImage
            textField
            Spacer()
            rightImage
        }
        .padding(Constants.Spacing.s)
        .overlay {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(borderColor, lineWidth: borderWidth)
        }
        .background(Color.white)
        .cornerRadius(Constants.cornerRadius)
        .modifier(LightShadowModifier())
    }
    
    @ViewBuilder var textField: some View {
        Group {
            if textFieldType == .password, isPasswordHidden {
                SecureField(placeholderText, text: $text)
            } else {
                TextField(placeholderText, text: $text)
            }
        }
        .font(Fonts.makeFont(.regular, size: Constants.FontSizes.small))
        .foregroundColor(Colors.dark)
    }
    
    var secureField: some View {
        SecureField(placeholderText, text: $text)
            .font(Fonts.makeFont(.regular, size: Constants.FontSizes.small))
            .foregroundColor(Colors.dark)
    }
    
    var leftImage: some View {
        Image(leftImageName)
            .renderingMode(.template)
            .foregroundColor(Colors.gray)
    }
    
    @ViewBuilder var rightImage: some View {
        if textFieldType == .password {
            Image(isPasswordHidden ? Images.icnEyeOff : Images.icnEye)
                .renderingMode(.template)
                .foregroundColor(Colors.gray)
                .onTapGesture {
                    isPasswordHidden.toggle()
                }
        }
    }
}

struct BorderedTextField_Previews: PreviewProvider {
    static var previews: some View {
        BorderedTextField(text: .constant("Keks"), verificationError: .constant(.none), textFieldType: .userName)
    }
}
