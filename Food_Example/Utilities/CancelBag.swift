//
//  CancelBag.swift
//  Food_Example
//
//  Created by Артур Кулик on 20.01.2023.
//

import Combine
import Foundation

final class CancelBag {
    fileprivate var subscriptions = Set<AnyCancellable>()
    
    func cancel() {
        subscriptions.removeAll()
    }
}

extension AnyCancellable {
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
