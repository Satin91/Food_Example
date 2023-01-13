//
//  LargeShadowModifier.swift
//  Food_Example
//
//  Created by Артур Кулик on 13.01.2023.
//

import SwiftUI

struct LargeShadowModifier: ViewModifier {
    let shadowRaduis: CGFloat = 22
    let yOffset: CGFloat = 40
    let opacity: CGFloat = 0.32
    
    func body(content: Content) -> some View {
        content
            .shadow(
                color: Color.black.opacity(opacity),
                radius: shadowRaduis,
                y: yOffset
            )
    }
}
