//
//  ReadSize.swift
//  Food_Example
//
//  Created by Артур Кулик on 13.01.2023.
//

import SwiftUI

struct ContentView: View {
    @State var frame: CGSize = .zero
    var body: some View {
        HStack {
            GeometryReader { geometry in
                self.makeView(geometry)
            }
        }
    }
    
    func makeView(_ geometry: GeometryProxy) -> some View {
        print(geometry.size.width, geometry.size.height)
        DispatchQueue.main.async { self.frame = geometry.size }
        return Text("Test")
            .frame(width: geometry.size.width)
    }
}

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
