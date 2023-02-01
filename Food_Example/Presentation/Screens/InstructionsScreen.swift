//
//  InstructionsScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 01.02.2023.
//

import SwiftUI

struct InstructionsScreen: View {
    let url: URL
    let rectSize = CGSize(width: 42, height: 4)
    
    var body: some View {
        content
    }
    private var content: some View {
        VStack {
            navigationView
            WebView(url: url)
        }
        .ignoresSafeArea(.all)
    }
    
    private var navigationView: some View {
        NavigationBarView()
            .addCentralContainer {
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: rectSize.width, height: rectSize.height)
                    .foregroundColor(Colors.neutralGray)
            }
    }
}

struct InstructionsScreen_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsScreen(url: URL(string: "https://www.fontspace.com")!)
    }
}
