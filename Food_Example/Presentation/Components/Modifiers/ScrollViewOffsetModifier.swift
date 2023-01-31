//
//  ScrollViewOffsetModifier.swift
//  Food_Example
//
//  Created by Артур Кулик on 28.01.2023.
//

import SwiftUI

private struct ScrollOffsetKey: PreferenceKey {
    typealias Value = CGPoint
    
    static var defaultValue = CGPoint.zero
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        let nextPoint = nextValue()
        value.x += nextPoint.x
        value.y += nextPoint.y
    }
}

struct OffsetInScrollView: View {
    let named: String
    
    var body: some View {
        GeometryReader { proxy in
            let offset = CGPoint(x: proxy.frame(in: .named(named)).minX, y: proxy.frame(in: .named(named)).minY)
            Color.clear.preference(key: ScrollOffsetKey.self, value: offset)
        }
    }
}

struct OffsetOutScrollModifier: ViewModifier {
    @Binding var offset: CGPoint
    
    let named: String
    
    func body(content: Content) -> some View {
        content
            .coordinateSpace(name: named)
            .onPreferenceChange(ScrollOffsetKey.self) { value in
                offset = value
                print(offset)
            }
    }
}
