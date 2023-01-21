//
//  Popup.swift
//  Food_Example
//
//  Created by Артур Кулик on 21.01.2023.
//

import SwiftUI

struct CentralPopupView<Content: View>: View {
    @Binding var isPresented: Bool
    @State var title: String
    let normalScaleFactor: CGFloat = 1
    let reducedScaleFactor: CGFloat = 0.5
    let increasedScaleFactor: CGFloat = 1.2
    let animationSpeed: CGFloat = 0.15
    var content: () -> Content
    
    var body: some View {
        VStack(spacing: Constants.Spacing.m) {
            titleLabel
            content()
            closeButton
        }
        .padding(Constants.Spacing.m)
        .background(Colors.backgroundWhite)
        .cornerRadius(Constants.cornerRadius)
        .padding(.vertical, Constants.Spacing.m)
        .padding(.horizontal, Constants.Spacing.xl)
        .scaleEffect(isPresented ? normalScaleFactor : reducedScaleFactor)
        .opacity(isPresented ? 1 : 0)
        .modifier(LargeShadowModifier())
        .animation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.6), value: isPresented)
    }
    
    var titleLabel: some View {
        Text(title)
            .font(Fonts.makeFont(.bold, size: Constants.FontSizes.upperMedium))
            .foregroundColor(Colors.dark)
            .multilineTextAlignment(.center)
    }
    
    var closeButton: some View {
        HStack {
            Spacer()
            CapsuleButton(title: "Close", size: .small) {
                isPresented.toggle()
            }
            .frame(width: Constants.ButtonWidth.small)
        }
    }
}

struct OverlayModifier<OverlayView: View>: ViewModifier {
    @Binding var isPresented: Bool
    let overlayView: OverlayView
    
    init(isPresented: Binding<Bool>, @ViewBuilder overlayView: @escaping () -> OverlayView) {
        self._isPresented = isPresented
        self.overlayView = overlayView()
    }
    
    func body(content: Content) -> some View {
        content.overlay(overlayView)
    }
}

extension View {
    func popup<OverlayView: View>(
        isPresented: Binding<Bool>,
        blurRadius: CGFloat = 3,
        blurAnimation: Animation? = .linear,
        @ViewBuilder overlayView: @escaping () -> OverlayView
    ) -> some View {
        blur(radius: isPresented.wrappedValue ? blurRadius : 0)
            .animation(.easeInOut, value: isPresented.wrappedValue)
            .allowsHitTesting(!isPresented.wrappedValue)
            .modifier(OverlayModifier(isPresented: isPresented, overlayView: overlayView))
    }
}
