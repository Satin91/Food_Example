//
//  ShadowModifiers.swift
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

struct SmallShadowModifier: ViewModifier {
    let shadowRaduis: CGFloat = 4
    let yOffset: CGFloat = 4
    let opacity: CGFloat = 0.12
    
    func body(content: Content) -> some View {
        content
            .shadow(
                color: Color.black.opacity(opacity),
                radius: shadowRaduis,
                y: yOffset
            )
    }
}

struct LightShadowModifier: ViewModifier {
    let color: Color
    let shadowRaduis: CGFloat = 30
    let yOffset: CGFloat = 15
    let opacity: CGFloat = 0.9
    
    init(color: Color = Colors.border) {
        self.color = color
    }
    
    func body(content: Content) -> some View {
        content
            .shadow(
                color: color.opacity(opacity),
                radius: shadowRaduis,
                y: yOffset
            )
    }
}
