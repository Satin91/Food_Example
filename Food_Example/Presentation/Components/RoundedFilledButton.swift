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
    let pressedScaleFactor: CGFloat = 0.98
    let initialScaleFactor: CGFloat = 1.0
    let animateDuration: CGFloat = 0.1
    
    @State var isPressed = false
    @State var currentScaleFactor: CGFloat = 1.0
    
    var body: some View {
        content
    }
    
    private var content: some View {
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
            .foregroundColor(Colors.red)
            .frame(height: Constants.ButtonHeight.large)
            .padding(.horizontal, Constants.Spacing.s)
            .animation(.easeInOut(duration: 0.3), value: isPressed)
            .modifier(LightShadowModifier(color: Colors.red.opacity(0.3)))
            .overlay {
                Text(text)
                    .font(Fonts.makeFont(.bold, size: Constants.FontSizes.medium))
                    .foregroundColor(.white)
                    .opacity(isPressed ? 0.3 : 1)
            }
            .onTapGesture {
                animate()
                action()
            }
            .scaleEffect(currentScaleFactor)
    }
    
    private func animate() {
        withAnimation(Animation.easeInOut(duration: animateDuration)) {
            currentScaleFactor = pressedScaleFactor
            isPressed = true
        }
        withAnimation(Animation.linear(duration: animateDuration).delay(animateDuration)) {
            currentScaleFactor = initialScaleFactor
            isPressed = false
        }
    }
}

struct RoundedFilledButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundedFilledButton(text: "Button", action: {})
    }
}
