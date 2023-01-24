//
//  ButtonTappedModifier.swift
//  Food_Example
//
//  Created by Артур Кулик on 18.01.2023.
//

import SwiftUI

struct ButtonTappedModifier: ViewModifier {
    @State var currentScaleFactor: CGFloat = 1
    @State var isAnimate = false
    let tappedScaleFactor: CGFloat = 0.9
    let normalScaleFactor: CGFloat = 1
    
    func body(content: Content) -> some View {
        content
    }
    
    func animate() {
        isAnimate.toggle()
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
