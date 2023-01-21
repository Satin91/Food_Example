//
//  NavigationButton.swift
//  Food_Example
//
//  Created by Артур Кулик on 13.01.2023.
//

import SwiftUI

struct OnboardingNavigationButton: View {
    @Binding var currentStep: Int
    
    var body: some View {
        content
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
            .foregroundColor(Colors.lightGray)
            .frame(width: 2, height: 24)
    }
    
    private func nextStep() {
        if currentStep != 4 {
            currentStep += 1
        }
    }
    
    private func previousStep() {
        if currentStep != 0 {
            currentStep -= 1
        }
    }
}

struct NavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingNavigationButton(currentStep: .constant(0))
            .background(Color.black)
    }
}
