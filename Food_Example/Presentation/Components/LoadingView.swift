//
//  LoadingView.swift
//  Food_Example
//
//  Created by Артур Кулик on 31.01.2023.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        LottieView(name: Lottie.loader, loopMode: .loop, isStopped: false)
            .frame(width: Constants.loaderLottieSize, height: Constants.loaderLottieSize)
            .toolbar(.hidden)
    }
}
