//
//  AccountSettingsScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 28.02.2023.
//

import FirebaseAuth
import SwiftUI

struct AccountSettingsScreen: View {
    var back: () -> Void
    @State var isPresentPopup = false
    @State var nameText = ""
    @State var emailText = ""
    @State var errorCode: AuthErrorCode.Code?
    @State var errorText = "Error"
    @Environment(\.injected) var container: DIContainer
    var body: some View {
        content
            .toolbar(.hidden)
            .popup(isPresented: $isPresentPopup, type: .center, overlayView: {
                TopPopupView(isPresented: $isPresentPopup, title: $errorText)
            })
            .onAppear {
                nameText = container.appState.value.user.username
                emailText = container.appState.value.user.email
            }
    }
    
    private var content: some View {
        VStack {
            navigationBar
            textFields
            Spacer()
            saveButton
        }
    }
    
    private var navigationBar: some View {
        NavigationBarView()
            .addLeftContainer {
                NavBarButton {
                    back()
                }
            }
            .addCentralContainer {
                Text("Edit Account")
                    .modifier(NavBarTextModifier())
            }
    }
    
    private var textFields: some View {
        VStack {
            borderedTextField(title: "Name", text: $nameText, image: Images.icnUserSettings)
            borderedTextField(title: "Email", text: $emailText, image: Images.icnMessage)
        }
        .padding(.horizontal, Constants.Spacing.s)
    }
    
    private var saveButton: some View {
        RoundedFilledButton(text: "Save Changes") {
            container.interactors.userInteractor.updateUser(name: nameText, email: emailText) { error in
                if let error {
                    errorText = error.code.description
                    isPresentPopup.toggle()
                } else {
                    isPresentPopup.toggle()
                    self.back()
                }
            }
        }
    }
    
    private func borderedTextField(title: String, text: Binding<String>, image: String) -> some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.xxs) {
            Text(title)
                .font(Fonts.makeFont(.bold, size: Constants.FontSizes.large))
                .foregroundColor(Colors.weakDark)
            HStack {
                Image(image)
                    .resizable()
                    .frame(width: 20, height: 20)
                TextField("", text: text)
                    .font(Fonts.makeFont(.medium, size: Constants.FontSizes.small))
            }
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Colors.neutralGray, lineWidth: 1)
            }
        }
    }
}

struct AccountSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettingsScreen(back: {})
    }
}
