//
//  NavBarButton.swift
//  Food_Example
//
//  Created by Артур Кулик on 28.02.2023.
//

import SwiftUI

struct NavBarButton: View {
    @State var buttonSize: CGSize = .zero
    var action: () -> Void
    
    var body: some View {
        content
            .onTapGestureAnimated {
                action()
            }
    }
    
    private var content: some View {
        Image(Images.icnChevronLeft)
            .renderingMode(.template)
            .foregroundColor(Colors.weakDark)
            .padding(Constants.Spacing.xs)
            .overlay {
                Circle()
                    .stroke(Colors.neutralGray, lineWidth: 1)
                    .foregroundColor(.clear)
            }
    }
}

struct NavBarButton_Previews: PreviewProvider {
    static var previews: some View {
        NavBarButton(action: {})
    }
}
