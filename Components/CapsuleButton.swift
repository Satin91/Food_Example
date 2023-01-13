//
//  CapsuleButton.swift
//  Food_Example
//
//  Created by Артур Кулик on 13.01.2023.
//

import SwiftUI

struct CapsuleButton: View {
    let title: String
    let action: () -> Void
    let capsuleHeight: CGFloat = 48
    var body: some View {
        capsuleButton
    }
    var capsuleButton: some View {
        Capsule()
            .foregroundColor(Color.red)
            .frame(height: capsuleHeight)
            .overlay(
                text  
            )
            .onTapGesture {
                action()
            }
    }
    var text: some View {
        Text(title)
            .font(Fonts.custom(.dmSans, size: Constants.FontSizes.medium))
            .foregroundColor(Color.white)
    }
}

struct CapsuleButton_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleButton(title: "", action: {})
    }
}
