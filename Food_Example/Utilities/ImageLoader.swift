//
//  ImageLoader.swift
//  Food_Example
//
//  Created by Артур Кулик on 26.01.2023.
//

import Combine
import Foundation
import UIKit

class ImageLoader: ObservableObject {
    @Published var image = UIImage()
    var cancelBag = Set<AnyCancellable>()
    let imageCache = ImageCache.shared
    
    func loadImage(urlString: String) {
        if self.loadImageFromCache(urlString: urlString) {
        } else {
            self.loadImageFromURL(urlString: urlString)
        }
    }
    
    private func loadImageFromCache(urlString: String) -> Bool {
        guard let cacheImage = imageCache.get(forKey: urlString) else {
            return false
        }
        image = cacheImage
        return true
    }
    
    private func loadImageFromURL(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .tryMap { data -> UIImage in
                guard let image = UIImage(data: data) else {
                    throw APIRequestError.imageDeserialization
                }
                return image
            }
            .sink { _ in
            } receiveValue: { image in
                self.imageCache.set(forKey: urlString, image: image)
                self.image = image
            }
            .store(in: &cancelBag)
    }
}

class ImageCache {
    let cache = NSCache<NSString, UIImage>()
    
    func get(forKey: String) -> UIImage? {
        cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
}

extension ImageCache {
    static var shared = ImageCache()
}
