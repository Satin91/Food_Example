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
    let type: TextFieldType
    let borderWidth: CGFloat = 1
    
    var title: String {
        switch type {
        case .userName:
            return "Username"
        case .email:
            return "Email address"
        case .password:
            return "Password"
        }
    }
    
    var placeholderText: String {
        switch type {
        case .userName:
            return "Enter your name"
        case .email:
            return "Myemail@mail.com"
        case .password:
            return "At least 8 characters"
        }
    }
    
    var rightImageName: String {
        switch type {
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
            if type == .password {
                rightImage
            }
        }
        .padding(Constants.Spacing.s)
        .overlay {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(Colors.border, lineWidth: borderWidth)
            
        }
    }
    
    var textField: some View {
        TextField(placeholderText, text: $text)
            .font(Fonts.custom(.regular, size: Constants.FontSizes.small))
            .foregroundColor(Colors.dark)
    }
    
    var leftImage: some View {
        Image(rightImageName)
            .renderingMode(.template)
            .foregroundColor(Colors.gray)
    }
    
    var rightImage: some View {
        Image(Images.icnEyeOff)
            .renderingMode(.template)
            .foregroundColor(Colors.gray)
    }
}

struct BorderedTextField_Previews: PreviewProvider {
    static var previews: some View {
        BorderedTextField(text: .constant("Keks"), type: .userName)
    }
}
