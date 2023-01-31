//
//  HTMLTextView.swift
//  Food_Example
//
//  Created by Артур Кулик on 31.01.2023.
//

import SwiftUI

struct HTMLTextView: View {
    let parser = HTMLParser()
    let text: String
    
    var body: some View {
        attributedTextView
    }
    
    @ViewBuilder var attributedTextView: some View {
        let textForAttribute = parser.getExcerpt(text: text)
        let replacedText = parser.removeMarkups(text: text)
        Text(replacedText) { string in
            string.foregroundColor = Colors.gray
            string.font = Fonts.makeFont(.medium, size: Constants.FontSizes.medium)
            for phrase in textForAttribute {
                if let range = string.range(of: phrase) {
                    string[range].foregroundColor = Colors.weakDark
                    string[range].font = Fonts.makeFont(.bold, size: Constants.FontSizes.medium)
                }
            }
        }
    }
}

struct HTMLTextView_Previews: PreviewProvider {
    static var previews: some View {
        HTMLTextView(text: "Text")
    }
}
