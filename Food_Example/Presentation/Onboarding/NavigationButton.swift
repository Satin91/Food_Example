//
//  NavigationButton.swift
//  Food_Example
//
//  Created by Артур Кулик on 13.01.2023.
//

import SwiftUI

struct NavigationButton: View {
    @Binding var currentStep: Int
    
    var body: some View {
        navigationButton
    }
    
    var navigationButton: some View {
        RoundedRectangle(cornerRadius: 16)
            .frame(width: 154, height: 64)
            .foregroundColor(Color(Colors.backgroundWhite))
            .overlay(
                HStack {
                    Image(Images.icnArrowRight)
                        .renderingMode(.template)
                        .foregroundColor(currentStep == 0 ? Color(Colors.placeholder) : Color(Colors.dark))
                        .onTapGesture {
                            previousStep()
                        }
                    Spacer()
                    verticalSeparator
                    Spacer()
                    Image(Images.icnArrowLeft)
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
            .foregroundColor(Color(Colors.lightGray))
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
        NavigationButton(currentStep: .constant(0))
            .background(Color.black)
    }
}
