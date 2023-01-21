//
//  CapsuleButton.swift
//  Food_Example
//
//  Created by Артур Кулик on 13.01.2023.
//

import SwiftUI

struct CapsuleButton: View {
    enum CapsuleButtonSize {
        case small
        case medium
    }
    
    let title: String
    let size: CapsuleButtonSize
    
    var capsuleHeight: CGFloat {
        switch size {
        case .small:
            return Constants.ButtonHeight.small
        case .medium:
            return Constants.ButtonHeight.medium
        }
    }
    let action: () -> Void
    
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
            .font(Fonts.makeFont(.dmSans, size: Constants.FontSizes.medium))
            .foregroundColor(Color.white)
    }
    
    init(title: String, size: CapsuleButtonSize = .medium, action: @escaping () -> Void) {
        self.title = title
        self.action = action
        self.size = size
    }
}

struct CapsuleButton_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleButton(title: "", action: {})
    }
}
