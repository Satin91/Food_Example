//
//  RecipesInteractor.swift
//  Food_Example
//
//  Created by Артур Кулик on 23.01.2023.
//

import Combine
import SwiftUI

enum ApiServerError: Error {
    case badURL
    case badConnection
    case requestError
    case statusError
}

protocol RecipesInteractor {
    func showRandomRecipes()
    func searchRecipesBy(params: RecipesRequestParams, completion: @escaping ([Recipe]) -> Void)
    func getRecipeInfoBy(id: Int, completion: @escaping (Recipe) -> Void)
}

class RecipesInteractorImpl: RecipesInteractor {
    var recipesWebRepository: RecipesWebRepository
    var cancelBag = Set<AnyCancellable>()
    
    init(recipesWebRepository: RecipesWebRepository) {
        self.recipesWebRepository = recipesWebRepository
    }
    
    func searchRecipesBy(params: RecipesRequestParams, completion: @escaping ([Recipe]) -> Void) {
        do {
            try recipesWebRepository.searchRecipes(model: SearchRecipesWrapper.self, params: params.URLParams, path: .searchByName)
                .sink(receiveCompletion: { error in
                    print("Error parse request with params \(error)")
                }, receiveValue: { wrapper in
                    completion(wrapper.results)
                })
                .store(in: &cancelBag)
        } catch let error {
            print("Error getting search result \(error)")
        }
    }
    
    func getRecipeInfoBy(id: Int, completion: @escaping (Recipe) -> Void) {
        do {
            try recipesWebRepository.searchRecipes(model: Recipe.self, params: RecipesRequestParams().URLParams, path: .recipeInfo(id))
                .sink(receiveCompletion: { error in
                    print("Error to get recipe by ID \(error)")
                }, receiveValue: { recipe in
                    completion(recipe)
                })
                .store(in: &cancelBag)
        } catch let error {
            print("Recipe parse error\(error)")
        }
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
    
    func getRecipeInfoBy(id: Int, completion: @escaping (Recipe) -> Void) {
    }
}
