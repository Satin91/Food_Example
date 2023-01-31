//
//  SegmentedView.swift
//  Food_Example
//
//  Created by Артур Кулик on 31.01.2023.
//

import SwiftUI

struct SegmentedView: View {
    /* The itemSizes property stores the width of the text.
    It is needed so that the underline matches the width of the text.
    */
    @State var itemSizes: [Int: CGFloat] = [:]
    @Binding var selectedIndex: Int
    
    var body: some View {
        content
    }
    
    private var content: some View {
        VStack(spacing: Constants.Spacing.xxxs) {
            segmentedView
            underline
        }
        .padding(Constants.Spacing.s)
    }
    
    // If the SegmentedView needs to be reused, changes will be made to the initializer and rendering will happen automatically, now this is not required.
    var segmentedView: some View {
        HStack(spacing: .zero) {
            SegmentedItem(index: 0, title: "Ingridients", selectedIndex: $selectedIndex) { width in
                itemSizes[0] = width
            }
            SegmentedItem(index: 1, title: "Summary", selectedIndex: $selectedIndex) { width in
                itemSizes[1] = width
            }
            SegmentedItem(index: 2, title: "Instructions", selectedIndex: $selectedIndex) { width in
                itemSizes[2] = width
            }
        }
    }
    private var underline: some View {
        HStack(spacing: .zero) {
            if selectedIndex == 2 {
                spacers
            }
            Rectangle()
                .foregroundColor(Color.clear)
                .background {
                    Rectangle()
                        .frame(width: itemSizes[selectedIndex])
                        .cornerRadius(2)
                        .foregroundColor(Colors.red)
                }
                .frame(height: 4)
            if selectedIndex == 0 {
                spacers
            }
        }
        .animation(.easeOut(duration: 0.2), value: selectedIndex)
    }
    
    /* Two spacers are needed to evenly distribute the space so that the underline is in the center of any of the three elements of the HStack
    */
    private var spacers: some View {
        Group {
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

struct SegmentedItem: View {
    let index: Int
    let title: String
    @Binding var selectedIndex: Int
    let textWidth: (CGFloat) -> Void
    var isSelected: Bool {
        index == selectedIndex
    }
    
    var body: some View {
        content
            .onTapGesture {
                selectedIndex = index
            }
    }
    
    var content: some View {
        Text(title)
            .font(Fonts.makeFont(.medium, size: Constants.FontSizes.medium))
            .foregroundColor(isSelected ? Colors.dark : Colors.weakGray)
            .readSize { size in
                textWidth(size.width)
            }
            .frame(maxWidth: .infinity)
    }
}
