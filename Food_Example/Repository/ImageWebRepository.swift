//
//  ImageWebRepository.swift
//  Food_Example
//
//  Created by Артур Кулик on 26.01.2023.
//

import Combine
import UIKit

protocol ImageWebRepository {
    func load(path: String) -> AnyPublisher<UIImage, Error>
}

struct ImageWebRepositoryImpl: ImageWebRepository {
    func load(path: String) -> AnyPublisher<UIImage, Error> {
        download(path: path)
    }
    
    private func download(path: String) -> AnyPublisher<UIImage, Error> {
        guard let url = URL(string: path) else {
            return Fail(outputType: UIImage.self, failure: APIRequestError.invalidURL).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .tryMap { data -> UIImage in
                guard let image = UIImage(data: data) else {
                    throw APIRequestError.imageDeserialization
                }
                return image
            }
            .eraseToAnyPublisher()
    }
}
