//
//  RoundedFilledButton.swift
//  Food_Example
//
//  Created by Артур Кулик on 14.01.2023.
//

import SwiftUI

struct RoundedFilledButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        roundedFilledButton
    }
    
    private var roundedFilledButton: some View {
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
            .foregroundColor(Colors.red)
            .frame(height: Constants.ButtonHeight.large)
            .padding(.horizontal, Constants.Spacing.s)
            .overlay {
                Text(text)
                    .font(Fonts.custom(.bold, size: Constants.FontSizes.medium))
                    .foregroundColor(.white)
            }
            .onTapGesture {
                action()
            }
    }
}

struct RoundedFilledButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundedFilledButton(text: "Button", action: {})
    }
}
