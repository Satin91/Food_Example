//
//  AccountSettingsScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 28.02.2023.
//

import SwiftUI

struct AccountSettingsScreen: View {
    var body: some View {
        content
            .toolbar(.hidden)
    }
    
    private var content: some View {
        VStack {
            navigationBar
            Text("TEXT")
            Spacer()
        }
    }
    
    private var navigationBar: some View {
        NavigationBarView()
            .addLeftContainer {
                NavBarButton {
                    print("Back to account screen")
                }
            }
            .addCentralContainer {
                Text("Edit Account")
                    .modifier(NavBarTextModifier())
            }
    }
}

struct AccountSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettingsScreen()
    }
}
