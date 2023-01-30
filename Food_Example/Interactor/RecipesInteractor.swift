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
    
    func getRecipeInfoBy(id: Int, completion: @escaping (Result<Recipe, Error>) -> Void) {
        var recipe: Recipe?
        let semaphore = DispatchSemaphore(value: 1)
        
        semaphore.wait()
        getRecipeInfo(id: id) { result in
            print("Thread \(Thread.current)")
            semaphore.signal()
            switch result {
            case .success(let receiveValue):
                recipe = receiveValue
            case .failure(let error):
                completion(.failure(error))
            }
        }
        semaphore.wait()
        setRecipeNutritionsBy(id: id) { result in
            semaphore.signal()
            print("Thread \(Thread.current)")
            switch result {
            case .success(let receiveValue):
                recipe?.nutrients = receiveValue
            case .failure(let error):
                completion(.failure(error))
            }
        }
        semaphore.wait()
        setRecipeIngridientsBy(id: id) { result in
            print("Thread \(Thread.current)")
            semaphore.signal()
            switch result {
            case .success(let receiveValue):
                recipe?.ingridients = receiveValue
                guard let recipe = recipe else {
                    completion(.failure(ApiServerError.statusError))
                    print("ERROR STATUS ERROR")
                    return
                }
                completion(.success(recipe))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getRecipeInfo(id: Int, completion: @escaping (Result<Recipe, Error>) -> Void) {
        print("getRecipeInfo on \(Thread.current)")
        recipesWebRepository.searchRecipes(model: Recipe.self, params: RecipesRequestParams().URLParams, path: .recipeInfo(id))
            .eraseToAnyPublisher()
            .sink { error in
                print("ERROR INFO \(error)")
            } receiveValue: { recipe in
                completion(.success(recipe))
            }
            .store(in: &cancelBag)
    }
    
    private func setRecipeNutritionsBy(id: Int, completion: @escaping (Result<Nutritient, Error>) -> Void) {
        recipesWebRepository.searchRecipes(model: Nutritient.self, params: RecipesRequestParams().URLParams, path: .nutritions(id))
            .sink { error in
                print("ERROR NUTRITIONS \(error)")
                completion(.failure(ApiServerError.requestError))
            } receiveValue: { nutritients in
                completion(.success(nutritients))
            }
            .store(in: &cancelBag)
    }
    
    private func setRecipeIngridientsBy(id: Int, completion: @escaping (Result<[Ingredient], Error>) -> Void) {
        recipesWebRepository.searchRecipes(model: IngredientWrapper.self, params: RecipesRequestParams().URLParams, path: .ingridients(id))
            .sink { error in
                print("ingridient error \(error)")
            } receiveValue: { ingridient in
                completion(.success(ingridient.ingredients))
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
