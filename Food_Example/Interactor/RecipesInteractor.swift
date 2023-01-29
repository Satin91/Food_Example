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
    func getRecipeInfoBy(id: Int, completion: @escaping (Result<Recipe, Error>) -> Void)
}

class RecipesInteractorImpl: RecipesInteractor {
    var recipesWebRepository: RecipesWebRepository
    var cancelBag = Set<AnyCancellable>()
    
    let semaphore = DispatchSemaphore(value: 1)
    
    init(recipesWebRepository: RecipesWebRepository) {
        self.recipesWebRepository = recipesWebRepository
    }
    func searchRecipesBy(params: RecipesRequestParams, completion: @escaping ([Recipe]) -> Void) {
        recipesWebRepository.searchRecipes(model: SearchRecipesWrapper.self, params: params.URLParams, path: .searchByName)
            .sink(receiveCompletion: { error in
                print("Error parse request with params \(error)")
            }, receiveValue: { wrapper in
                completion(wrapper.results)
            })
            .store(in: &cancelBag)
    }
    
    @MainActor
    func getRecipeInfoBy(id: Int, completion: @escaping (Result<Recipe, Error>) -> Void) {
        var recipe: Recipe?
        getRecipeInfo(id: id) { result in
            switch result {
            case .success(let receiveValue):
                recipe = receiveValue
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        setRecipeNutritionsBy(id: id) { result in
            switch result {
            case .success(let receiveValue):
                recipe?.nutrients = receiveValue
                guard let recipe = recipe else {
                    completion(.failure(ApiServerError.requestError))
                    return
                }
                completion(.success(recipe))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func getRecipeInfo(id: Int, completion: @escaping (Result<Recipe, Error>) -> Void) {
        print("getRecipeInfo on \(Thread.current)")
        semaphore.wait()
        recipesWebRepository.searchRecipes(model: Recipe.self, params: RecipesRequestParams().URLParams, path: .recipeInfo(id))
            .sink { _ in
                // completion(.failure(ApiServerError.badConnection))
            } receiveValue: { recipe in
                completion(.success(recipe))
                self.semaphore.signal()
            }
            .store(in: &cancelBag)
    }
    
    private func setRecipeNutritionsBy(id: Int, completion: @escaping (Result<Nutritient, Error>) -> Void) {
        print("setRecipeNutritionsBy on \(Thread.current)")
        self.semaphore.wait()
        recipesWebRepository.searchRecipes(model: Nutritient.self, params: RecipesRequestParams().URLParams, path: .nutritions(id))
            .sink { error in
                print(error)
                completion(.failure(ApiServerError.requestError))
            } receiveValue: { nutritients in
                completion(.success(nutritients))
                self.semaphore.signal()
            }
            .store(in: &cancelBag)
    }
    
    func showRandomRecipes() {
    }
}

struct StubRecipesInteractor: RecipesInteractor {
    func getRecipeInfoBy(id: Int, completion: @escaping (Result<Recipe, Error>) -> Void) {
    }
    
    func showRandomRecipes() {
    }
    
    func searchRecipesBy(params: RecipesRequestParams, completion: @escaping ([Recipe]) -> Void) {
    }
}
