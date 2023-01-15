//
//  BorderedTextField.swift
//  Food_Example
//
//  Created by Артур Кулик on 13.01.2023.
//

import SwiftUI

struct BorderedTextField: View {
    enum TextFieldType {
        case email
        case password
        case userName
    }
    
    @Binding var text: String
    @State var isPasswordHidden = true
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
            return "At least 8 characters"
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
        VStack(alignment: .leading, spacing: Constants.Spacing.xxs) {
            titleView
            borderedTextFieldView
        }
        .padding(.horizontal, Constants.Spacing.s)
    }
    
    var titleView: some View {
        Text(title)
            .font(Fonts.custom(.medium, size: Constants.FontSizes.small))
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
                .stroke(Colors.border, lineWidth: borderWidth)
        }
    }
    
    @ViewBuilder var textField: some View {
        if textFieldType == .password, isPasswordHidden {
            SecureField(placeholderText, text: $text)
                .modifier(TextFieldModifier())
        } else {
            TextField(placeholderText, text: $text)
                .modifier(TextFieldModifier())
        }
    }
    
    var secureField: some View {
        SecureField(placeholderText, text: $text)
            .font(Fonts.custom(.regular, size: Constants.FontSizes.small))
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
        BorderedTextField(text: .constant("Keks"), textFieldType: .userName)
    }
}

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Fonts.custom(.regular, size: Constants.FontSizes.small))
            .foregroundColor(Colors.dark)
    }
}
