//
//  PopupModifier.swift
//  Food_Example
//
//  Created by Артур Кулик on 02.02.2023.
//

import SwiftUI

struct OverlayModifier<OverlayView: View>: ViewModifier {
    @Binding var isPresented: Bool
    let overlayView: OverlayView
    let type: PopupType
    
    @State private var contentSize = CGSize()
    @State private var overlaySize = CGSize()
    @State private var offset = CGSize()
    
    init(isPresented: Binding<Bool>, type: PopupType, @ViewBuilder overlayView: @escaping () -> OverlayView) {
        self._isPresented = isPresented
        self.overlayView = overlayView()
        self.type = type
    }
    
    func body(content: Content) -> some View {
        ZStack {
            readSizes(content: content)
            content.overlay(
                overlayView.offset(x: offset.width, y: offset.height)
            )
        }
    }
    
    func calculateOffset(type: PopupType) -> some View {
        switch type {
        case .center:
            break
        case .list:
            DispatchQueue.main.async {
                offset = listOffset()
            }
        }
        return Color.clear
            .frame(width: .zero, height: .zero)
    }
    
    @ViewBuilder private func readSizes(content: Content) -> some View {
        Group {
            content.readSize { size in self.contentSize = size }
            overlayView.readSize { size in self.overlaySize = size }
        }
        .opacity(0)
        .frame(width: .zero, height: .zero)
        calculateOffset(type: type)
    }
    
    private func centerOffset() -> CGSize {
        CGSize(width: 0, height: 0)
    }
    
    private func listOffset() -> CGSize {
        let size = CGSize(width: -(overlaySize.width / 2 - contentSize.width / 4), height: overlaySize.height / 2 + contentSize.height)
        return size
    }
}

extension View {
    func popup<OverlayView: View>(
        isPresented: Binding<Bool>,
        type: PopupType = .list,
        blurRadius: CGFloat = 3,
        blurAnimation: Animation? = .linear,
        @ViewBuilder overlayView: @escaping () -> OverlayView
    ) -> some View {
        let blurradius = type != .list && isPresented.wrappedValue ? blurRadius : 0
        return blur(radius: blurradius)
            .animation(.easeInOut, value: isPresented.wrappedValue)
            .allowsHitTesting(!isPresented.wrappedValue)
            .modifier(OverlayModifier(isPresented: isPresented, type: type, overlayView: overlayView))
    }
}

enum PopupType {
    case center
    case list
}
