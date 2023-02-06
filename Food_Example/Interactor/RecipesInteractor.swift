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
    func searchRecipesBy(params: RecipesRequestParams, path: APIEndpoint, completion: @escaping ([Recipe]) -> Void)
    func getRecipeInfoBy(id: Int, completion: @escaping (Result<Recipe, Error>) -> Void)
}

class RecipesInteractorImpl: RecipesInteractor {
    var recipesWebRepository: RecipesWebRepository
    var cancelBag = Set<AnyCancellable>()
    let dispatchGroup = DispatchGroup()
    
    init(recipesWebRepository: RecipesWebRepository) {
        self.recipesWebRepository = recipesWebRepository
    }
    
    func searchRecipesBy(params: RecipesRequestParams, path: APIEndpoint, completion: @escaping ([Recipe]) -> Void) {
        if path == .searchInAll {
            getRecipeInfo(model: SearchRecipesWrapper.self, params: params.URLParams, path: .searchInAll, id: 0) { result in
                switch result {
                case .success(let success):
                    completion(success.results)
                case .failure(let failure):
                    print(failure)
                }
            }
        } else {
            getRecipeInfo(model: [Recipe].self, params: params.URLParams, path: path, id: 0) { result in
                switch result {
                case .success(let success):
                    completion(success)
                case .failure(let failure):
                    print(failure)
                }
            }
        }
    }
    
    func getRecipeInfoBy(id: Int, completion: @escaping (Result<Recipe, Error>) -> Void) {
        var recipe: Recipe?
        var nutritients: Nutritient?
        var ingridients: [Ingredient]?
        
        getRecipeInfo(
            model: Recipe.self,
            params: [:],
            path: .recipeInfo(id),
            id: id
        ) { result in
            switch result {
            case .success(let receiveValue):
                recipe = receiveValue
            case .failure(let error):
                completion(.failure(error))
            }
        }
        getRecipeInfo(
            model: Nutritient.self,
            params: [:],
            path: .nutritions(id),
            id: id
        ) { result in
            switch result {
            case .success(let receiveValue):
                nutritients = receiveValue
            case .failure(let error):
                completion(.failure(error))
            }
        }
        getRecipeInfo(
            model: IngredientWrapper.self,
            params: [:],
            path: .ingridients(id),
            id: id
        ) { result in
            switch result {
            case .success(let receiveValue):
                ingridients = receiveValue.ingredients
            case .failure(let error):
                print(error)
            }
        }
        dispatchGroup.notify(queue: .main) {
            guard var recipe = recipe else {
                completion(.failure(APIRequestError.unexpectedResponse))
                return
            }
            recipe.nutrients = nutritients
            recipe.ingridients = ingridients
            completion(.success(recipe))
        }
    }
    
    func showRandomRecipes() {
    }
}

struct StubRecipesInteractor: RecipesInteractor {
    func searchRecipesBy(params: RecipesRequestParams, path: APIEndpoint, completion: @escaping ([Recipe]) -> Void) {
    }
    
    func getRecipeInfoBy(id: Int, completion: @escaping (Result<Recipe, Error>) -> Void) {
    }
    
    func showRandomRecipes() {
    }
}

extension RecipesInteractorImpl {
    private func getRecipeInfo<T: Decodable>(
        model: T.Type,
        params: [String: String],
        path: APIEndpoint,
        id: Int,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        dispatchGroup.enter()
        recipesWebRepository.searchRequest(model: model.self, params: params, path: path)
            .eraseToAnyPublisher()
            .sink { error in
                print(error)
            } receiveValue: { value in
                self.dispatchGroup.leave()
                completion(.success(value))
            }
            .store(in: &cancelBag)
    }
}
