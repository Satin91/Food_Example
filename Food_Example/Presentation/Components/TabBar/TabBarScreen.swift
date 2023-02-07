//
//  TabBarElement.swift
//  iosApp
//
//  Created by Артур Кулик on 05.10.2022.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI

protocol TabBarScreen: View {
    var tabImage: String { get }
    var tabSelectedColor: Color { get }
    var content: AnyView { get }
}

extension TabBarScreen {
    var content: AnyView {
        AnyView(self)
    }
}
