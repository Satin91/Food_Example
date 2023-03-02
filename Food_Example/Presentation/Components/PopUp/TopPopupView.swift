//
//  TopPopupView.swift
//  Food_Example
//
//  Created by Артур Кулик on 02.03.2023.
//

import SwiftUI

struct TopPopupView: View {
    @Binding var isPresented: Bool
    @Binding var title: String
    @State var offset = CGSize(width: 0, height: 0)
    @State var screenSize: CGSize = .zero
    let animationSpeed: CGFloat = 0.15
    
    var body: some View {
        VStack {
            VStack(spacing: Constants.Spacing.m) {
                titleLabel
            }
            .padding(Constants.Spacing.m)
            .background(Colors.backgroundWhite)
            .cornerRadius(Constants.cornerRadius)
            .padding(.vertical, Constants.Spacing.m)
            .frame(maxWidth: .infinity)
            .offset(isPresented ? offset : CGSize(width: screenSize.width, height: 0))
            .modifier(LargeShadowModifier())
            .animation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.6), value: isPresented)
            .padding(Constants.Spacing.s)
            Spacer()
        }
        .readSize(onChange: { screenSize in
            self.screenSize = screenSize
        })
        .onChange(of: isPresented) { newValue in
            guard newValue == true else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isPresented = false
            }
        }
    }
    
    var titleLabel: some View {
        Text(title)
            .font(Fonts.makeFont(.bold, size: Constants.FontSizes.extraMedium))
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
