//
//  RecipesDBRepository.swift
//  Food_Example
//
//  Created by Артур Кулик on 13.02.2023.
//

import Foundation
import RealmSwift

protocol RecipesDBRepository {
    var storage: Results<Storage> { get }
}

final class RecipesDBRepositoryImpl: RecipesDBRepository {
    @ObservedResults(Storage.self) var storage
    
    init() {
        createStorageIfNeed()
    }
    
    func createStorageIfNeed() {
        if storage.isEmpty {
            $storage.append(Storage())
        }
    }
}
