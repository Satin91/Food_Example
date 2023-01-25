//
//  ImageInteractor.swift
//  Food_Example
//
//  Created by Артур Кулик on 26.01.2023.
//

import Combine
import UIKit

protocol ImageInteractor {
    func load(path: String, completion: @escaping (UIImage, APIRequestError?) -> Void)
}

final class ImageInteractorImpl: ImageInteractor {
    let repository: ImageWebRepository
    private var cancelBag = Set<AnyCancellable>()
    
    init(repository: ImageWebRepository) {
        self.repository = repository
    }
    
    func load(path: String, completion: @escaping (UIImage, APIRequestError?) -> Void) {
        repository.load(path: path)
            .sink { error in
                print("Error to load image \(error)")
            } receiveValue: { image in
                completion(image, nil)
            }
            .store(in: &cancelBag)
    }
}

struct StubImageInteractor: ImageInteractor {
    func load(path: String, completion: @escaping (UIImage, APIRequestError?) -> Void) {
    }
}
