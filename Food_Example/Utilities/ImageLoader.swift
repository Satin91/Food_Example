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
    let ingredientImageSize: CGFloat = 100
    
    func downloadImage(urlString: String) {
        if self.loadImageFromCache(urlString: urlString) {
            print("Load from cache Image \(urlString)")
        } else {
            print("Download Image \(urlString)")
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
            } receiveValue: { [weak self] image in
                guard let self else { return }
                let croppedImage = self.cropImageIfNeed(imageToCrop: image)
                self.imageCache.set(forKey: urlString, image: croppedImage)
                DispatchQueue.main.async {
                    self.image = croppedImage
                }
            }
            .store(in: &cancelBag)
    }
    
    func cropImageIfNeed(imageToCrop: UIImage) -> UIImage {
        // ingredient images don't need to crop
        guard imageToCrop.size.width > ingredientImageSize else { return imageToCrop }
        guard imageToCrop.hasWhiteBorder() else { return imageToCrop }
        let imageRef = imageToCrop.cgImage!.cropping(to: CGRect(x: 50, y: 50, width: imageToCrop.size.width - 100, height: imageToCrop.size.height - 100))!
        let cropped = UIImage(cgImage: imageRef)
        return cropped
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
