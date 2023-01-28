//
//  GoogleButton.swift
//  Food_Example
//
//  Created by Артур Кулик on 14.01.2023.
//

import SwiftUI

struct GoogleButton: View {
    let borderWidth: CGFloat = 1
    let action: () -> Void
    
    var body: some View {
        content
            .onTapGesture {
                action()
            }
    }
    
    var content: some View {
        HStack {
            googleImage
            textView
        }
        .frame(maxWidth: .infinity)
        .padding(Constants.Spacing.s)
        .overlay {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(Colors.neutralGray, lineWidth: borderWidth)
        }
        .padding(.horizontal, Constants.Spacing.s)
    }
    
    private var googleImage: some View {
        Image(Images.icnGoogle)
    }
    
    private var textView: some View {
        Text("Continue with Google")
            .font(Fonts.makeFont(.medium, size: Constants.FontSizes.medium))
            .foregroundColor(Colors.dark)
    }
}

struct GoogleButton_Previews: PreviewProvider {
    static var previews: some View {
        GoogleButton(action: {})
    }
}
