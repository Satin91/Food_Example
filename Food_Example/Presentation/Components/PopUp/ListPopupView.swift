//
//  ListPopupView.swift
//  Food_Example
//
//  Created by Артур Кулик on 01.02.2023.
//

import SwiftUI

struct ListPopupView: View {
    @Binding var selectedIndex: Int
    @Binding var isPresent: Bool
    let listItems: [String]
    var body: some View {
        content
    }
    
    private var content: some View {
        list
    }
    
    @ViewBuilder private var list: some View {
        VStack {
            ForEach(0..<listItems.count, id: \.self) { index in
                VStack(spacing: Constants.Spacing.s) {
                    Text(listItems[index])
                        .font(Fonts.makeFont(.regular, size: Constants.FontSizes.minimum))
                        .foregroundColor(Colors.dark)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, Constants.Spacing.s)
                        .onTapGesture {
                            selectedIndex = index
                        }
                    if index != listItems.count - 1 {
                        RoundedRectangle(cornerRadius: 2)
                            .frame(height: 1.5)
                            .foregroundColor(Colors.backgroundWhite)
                    }
                }
            }
        }
        .fixedSize()
        .padding(.leading, Constants.Spacing.s)
        .padding(.vertical, Constants.Spacing.s)
        .background(.white)
        .cornerRadius(16)
        .modifier(LightShadowModifier())
        .opacity(isPresent ? 1 : 0)
        .background(Color.gray)
    }
}

struct ListPopup_Previews: PreviewProvider {
    static var previews: some View {
        ListPopupView(selectedIndex: .constant(0), isPresent: .constant(true), listItems: [])
    }
}
