//
//  ButtonTappedModifier.swift
//  Food_Example
//
//  Created by Артур Кулик on 18.01.2023.
//

import SwiftUI

struct AnimateButtonTapModifier: ViewModifier {
    @State var currentScaleFactor: CGFloat = 1
    @State var isAnimate = false
    @State var opacity: CGFloat = 1
    var parrentAction: () -> Void
    let tappedOpacity: CGFloat = 0.2
    let normalOpacity: CGFloat = 1
    
    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .onTapGesture {
                parrentAction()
                animate()
            }
    }
    
    func animate() {
        opacity = tappedOpacity
        withAnimation {
            opacity = normalOpacity
        }
    }
}

extension View {
    func onTapGestureAnimated(perform: @escaping () -> Void) -> some View {
        modifier(AnimateButtonTapModifier(parrentAction: perform))
    }
}
