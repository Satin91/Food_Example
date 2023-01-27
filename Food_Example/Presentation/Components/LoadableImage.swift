//
//  LoadableImage.swift
//  Food_Example
//
//  Created by Артур Кулик on 26.01.2023.
//

import SwiftUI

struct LoadableImage: View {
    let urlString: String
    @StateObject var imageLoader = ImageLoader()
    
    var body: some View {
        content
            .onAppear {
                imageLoader.loadImage(urlString: urlString)
            }
    }
    
    private var content: some View {
        Image(uiImage: imageLoader.image)
            .resizable()
            .scaledToFill()
    }
    
    private var image: some View {
        Image(uiImage: imageLoader.image)
    }
}

struct LoadableImage_Previews: PreviewProvider {
    static var previews: some View {
        LoadableImage(urlString: "https://mobimg.b-cdn.net/v3/fetch/91/91f15b2e0be2a8f4efcbcd9502006f97.jpeg")
    }
}
