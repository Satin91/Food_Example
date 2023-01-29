//
//  NavigationButton.swift
//  Food_Example
//
//  Created by Артур Кулик on 13.01.2023.
//

import SwiftUI

struct OnboardingNavigationButton: View {
    @Binding var currentStep: Int
    @State var isPressed = true
    @State var degrees: CGFloat = 0
    let duration: CGFloat = 3
    
    var body: some View {
        content
            .frame(width: 50, height: 34)
            .rotation3DEffect(Angle(degrees: degrees), axis: (x: 0, y: 1, z: 0))
            .foregroundColor(Colors.silver)
            .animation(.easeInOut(duration: 0.3), value: isPressed)
    }
    
    var content: some View {
        RoundedRectangle(cornerRadius: 16)
            .frame(width: 154, height: 64)
            .foregroundColor(Colors.backgroundWhite)
            .overlay(
                HStack {
                    Image(Images.icnArrowLeft)
                        .renderingMode(.template)
                        .foregroundColor(currentStep == 0 ? Colors.placeholder : Colors.dark)
                        .onTapGesture {
                            previousStep()
                        }
                    Spacer()
                    verticalSeparator
                    Spacer()
                    Image(Images.icnArrowRight)
                        .onTapGesture {
                            nextStep()
                        }
                }
                    .frame(width: 114)
            )
            .modifier(LargeShadowModifier())
    }
    
    private var verticalSeparator: some View {
        RoundedRectangle(cornerRadius: 2)
            .foregroundColor(Colors.silver)
            .frame(width: 2, height: 24)
    }
    
    private func nextStep() {
        if currentStep != 4 {
            currentStep += 1
            animate(isNext: true)
        }
    }
    
    private func previousStep() {
        if currentStep != 0 {
            currentStep -= 1
            animate(isNext: false)
        }
    }
    
    func animate(isNext: Bool) {
        withAnimation(Animation.easeInOut(duration: duration / 2)) {
            isPressed.toggle()
            degrees = isNext ? 8 : -8
        }
        withAnimation(Animation.easeOut(duration: duration / 2).delay(duration / 2)) {
            isPressed.toggle()
            degrees = 0
        }
    }
}

struct NavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingNavigationButton(currentStep: .constant(0))
            .background(Color.black)
    }
}
