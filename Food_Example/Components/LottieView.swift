//
//  LottieView.swift
//  Food_Example
//
//  Created by Артур Кулик on 21.01.2023.
//

import Lottie
import SwiftUI

struct LottieView: UIViewRepresentable {
    class Coordinator: NSObject {
        var parent: LottieView
        
        init(_ parent: LottieView) {
            self.parent = parent
        }
    }
    
    let name: String
    let loopMode: LottieLoopMode
    let speed: CGFloat
    
    var animationView = LottieAnimationView()
    var isStopped: Bool
    
    init(name: String, loopMode: LottieLoopMode, speed: CGFloat = 1, isStopped: Bool) {
        self.name = name
        self.loopMode = loopMode
        self.speed = speed
        self.isStopped = isStopped
    }
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> some UIView {
        let view = UIView(frame: .zero)
        let animation = LottieAnimation.named(name)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = speed
        animationView.loopMode = loopMode
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        return view
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<LottieView>) {
        if isStopped {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                context.coordinator.parent.animationView.stop()
            }
        } else {
            context.coordinator.parent.animationView.play { _ in
                context.coordinator.parent.isStopped = true
            }
        }
    }
}
