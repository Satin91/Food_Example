//
//  RecipesInteractor.swift
//  Food_Example
//
//  Created by Артур Кулик on 23.01.2023.
//

import Combine
import Foundation

enum ApiServerError: Error {
    case badURL
    case badConnection
    case requestError
    case statusError
}

protocol RecipesInteractor {
    func showRandomRecipes()
    func searchRecipesBy(params: RecipesRequestParams, completion: @escaping ([Recipe]) -> Void)
    func getRecipeInfo()
}

class RecipesInteractorImpl: RecipesInteractor {
    var recipesWebRepository: RecipesWebRepository
    var cancelBag = Set<AnyCancellable>()
    
    init(recipesWebRepository: RecipesWebRepository) {
        self.recipesWebRepository = recipesWebRepository
    }
    
    func searchRecipesBy(params: RecipesRequestParams, completion: @escaping ([Recipe]) -> Void) {
        do {
            try recipesWebRepository.searchRecipes(model: SearchRecipesWrapper.self, params: params.URLParams(), path: .searchByName)
                .sink(receiveCompletion: { error in
                    print(error)
                }, receiveValue: { wrapper in
                    completion(wrapper.results)
                })
                .store(in: &cancelBag)
        } catch let error {
            print(error)
        }
    }
    
    func getRecipes() {
    }
    
    func showRandomRecipes() {
    }
    
    func searchRecipesBy(query: String) {
    }
    
    func getRecipeInfo() {
    }
}

struct StubRecipesInteractor: RecipesInteractor {
    func showRandomRecipes() {
    }
    
    func searchRecipesBy(params: RecipesRequestParams, completion: @escaping ([Recipe]) -> Void) {
    }
    
    func getRecipeInfo() {
    }
}
