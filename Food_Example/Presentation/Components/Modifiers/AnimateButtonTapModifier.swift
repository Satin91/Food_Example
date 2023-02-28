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
    var parrentClosure: () -> Void
    let tappedScaleFactor: CGFloat = 0.9
    let normalScaleFactor: CGFloat = 1
    
    func body(content: Content) -> some View {
        content
            .opacity(isAnimate ? 0.2 : 1)
            .animation(.easeOut(duration: 0.1), value: isAnimate)
            .onTapGesture {
                parrentClosure()
                animate()
            }
    }
    
    func animate() {
        isAnimate.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isAnimate.toggle()
        }
    }
    
    func animateCircles() {
        var counter = 0
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            guard counter == 1 else {
                return
            }
            counter += 1
        }
    }
}

extension View {
    func onTapGestureAnimated(perform: @escaping () -> Void) -> some View {
        modifier(AnimateButtonTapModifier(parrentClosure: perform))
    }
}
