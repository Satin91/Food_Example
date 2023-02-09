//
//  AccountScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 09.02.2023.
//

import SwiftUI

struct AccountScreen: View, TabBarScreen {
    var tabImage: String = Images.icnUserFilled
    var tabSelectedColor: Color = Colors.blue
    
    var body: some View {
        content
            .toolbar(.hidden)
    }
    
    private var content: some View {
        VStack {
            navigationBar
            userContainer
            accountSettingsSection
            Spacer()
        }
    }
    
    private var navigationBar: some View {
        NavigationBarView()
            .addCentralContainer {
                Text("Settings")
                    .font(Fonts.makeFont(.bold, size: Constants.FontSizes.extraMedium))
                    .foregroundColor(Colors.dark)
            }
    }
    
    private var userContainer: some View {
        HStack(alignment: .center, spacing: Constants.Spacing.s) {
            Image(Images.imgUserBackground)
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: Constants.Spacing.xxxs) {
                Text("Some User")
                    .font(Fonts.makeFont(.bold, size: Constants.FontSizes.extraMedium))
                    .foregroundColor(Colors.dark)
                Text("@Username")
                    .font(Fonts.makeFont(.medium, size: Constants.FontSizes.medium))
                    .foregroundColor(Colors.weakGray)
            }
            Spacer(minLength: .zero)
        }
        .padding(.horizontal)
    }
    
    private var accountSettingsSection: some View {
        VStack(spacing: .zero) {
            sectionDivider(text: "ACCOUNT SETTINGS")
            settingRow(image: Images.icnUserSettings, text: "Edit Profile", action: {})
            settingRow(image: Images.icnShield, text: "Change Password", action: {})
            sectionDivider(text: "PREFERENCES")
            settingRow(image: Images.icnMoon, text: "Night Mode", action: {})
            settingRow(image: Images.icnLogout, text: "Log Out", action: {})
        }
    }
    
    private func sectionDivider(text: String) -> some View {
        Rectangle()
            .frame(maxWidth: .infinity)
            .frame(height: 32)
            .foregroundColor(Colors.backgroundWhite)
            .overlay {
                HStack {
                    Text(text)
                        .font(Fonts.makeFont(.medium, size: Constants.FontSizes.minimum))
                        .foregroundColor(Colors.weakGray)
                    Spacer()
                }
                .padding(.horizontal, Constants.Spacing.s)
            }
    }
    
    private func settingRow(image: String, text: String, action: () -> Void) -> some View {
        HStack(spacing: Constants.Spacing.s) {
            Image(image)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(Colors.weakGray)
                .frame(width: 12)
                .padding(10)
                .background {
                    Circle()
                        .foregroundColor(Colors.backgroundWhite)
                }
            Text(text)
                .font(Fonts.makeFont(.medium, size: Constants.FontSizes.minimum))
                .foregroundColor(Colors.weakDark)
            Spacer()
            Image(Images.icnChevronRight)
                .renderingMode(.template)
                .foregroundColor(Colors.silver)
        }
        .padding(Constants.Spacing.s)
    }
}

struct AccountScreen_Previews: PreviewProvider {
    static var previews: some View {
        AccountScreen()
    }
}
