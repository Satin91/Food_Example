//
//  RecipesInteractor.swift
//  Food_Example
//
//  Created by Артур Кулик on 23.01.2023.
//

import Combine
import RealmSwift
import SwiftUI

protocol RecipesInteractor {
    var storage: UserRealm { get set }
    
    func showRandomRecipes(completion: @escaping ([Recipe]) -> Void)
    func searchRecipesBy(params: RecipesRequestParams, path: APIEndpoint, completion: @escaping ([Recipe]) -> Void)
    func getRecipeInfoBy(id: Int, completion: @escaping (Result<Recipe, Error>) -> Void)
    func getRecipesInfoBy(ids: [Int], completion: @escaping ([Recipe]) -> Void)
    func saveUserToStorage(userInfo: UserInfo, favoriteRecipes: [Recipe])
    func saveFavorite(recipe: RecipeRealm)
    func removeFavorite(index: Int)
}

class RecipesInteractorImpl: RecipesInteractor {
    var recipesWebRepository: RecipesWebRepository
    var recipesDBRepository: RecipesDBRepository
    var cancelBag = Set<AnyCancellable>()
    let dispatchGroup = DispatchGroup()
    let searchRecipesDispatchGroup = DispatchGroup()
    @ObservedRealmObject var storage: UserRealm
    
    init(recipesWebRepository: RecipesWebRepository, recipesDBRepository: RecipesDBRepository) {
        self.recipesWebRepository = recipesWebRepository
        self.recipesDBRepository = recipesDBRepository
        self.storage = recipesDBRepository.storage[2]
    }
    
    // MARK: WEB
    func searchRecipesBy(params: RecipesRequestParams, path: APIEndpoint, completion: @escaping ([Recipe]) -> Void) {
        switch path {
        case .searchInAll:
            getRecipeInfo(model: SearchRecipesWrapper.self, params: params.URLParams, path: .searchInAll, id: 0) { result in
                switch result {
                case .success(let success):
                    completion(success.results!)
                case .failure(let failure):
                    print(failure)
                }
            }
        default:
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
            params: RecipesRequestParams(urlParams: [:]).URLParams,
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
            params: RecipesRequestParams(urlParams: [:]).URLParams,
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
            params: RecipesRequestParams(urlParams: [:]).URLParams,
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
    
    func showRandomRecipes(completion: @escaping ([Recipe]) -> Void) {
        let urlParams = RecipesRequestParams(urlParams: [:]).URLParams
        getRecipeInfo(
            model: SearchRecipesWrapper.self,
            params: urlParams,
            path: .randomRecipes,
            id: 0
        ) { result in
            switch result {
            case .success(let success):
                completion(success.recipes!)
            case .failure(let failure):
                print("Failure getting random recipes \(failure.localizedDescription)")
            }
        }
    }
    
    // MARK: DataBase
    func saveFavorite(recipe: RecipeRealm) {
        $storage.favoriteRecipes.append(recipe)
    }
    
    func removeFavorite(index: Int) {
        $storage.favoriteRecipes.remove(at: index)
    }
    
    func getRecipesInfoBy(ids: [Int], completion: @escaping ([Recipe]) -> Void) {
        var recipes: [Recipe] = []
        ids.forEach { id in
            searchRecipesDispatchGroup.enter()
            print("enter dispatchgroup")
            getRecipeInfoBy(id: id) { result in
                switch result {
                case .success(let recipe):
                    self.searchRecipesDispatchGroup.leave()
                    print("leave dispatchGroup")
                    recipes.append(recipe)
                case .failure(let failure):
                    self.searchRecipesDispatchGroup.leave()
                    print("failure \(failure)")
                }
            }
        }
        searchRecipesDispatchGroup.notify(queue: .main) {
            print("notify")
            completion(recipes)
        }
    }
    
    func saveUserToStorage(userInfo: UserInfo, favoriteRecipes: [Recipe]) {
        recipesDBRepository.saveUserToStorage(userInfo: userInfo, favoriteRecipes: favoriteRecipes)
    }
}

struct StubRecipesInteractor: RecipesInteractor {
    var storage = UserRealm()
    
    func saveUserToStorage(userInfo: UserInfo, favoriteRecipes: [Recipe]) {
    }
    
    func searchRecipesBy(params: RecipesRequestParams, path: APIEndpoint, completion: @escaping ([Recipe]) -> Void) {
    }
    
    func getRecipeInfoBy(id: Int, completion: @escaping (Result<Recipe, Error>) -> Void) {
    }
    
    func showRandomRecipes(completion: @escaping ([Recipe]) -> Void) {
    }
    
    func saveFavorite(recipe: RecipeRealm) {
    }
    
    func removeFavorite(index: Int) {
    }
    
    func getRecipesInfoBy(ids: [Int], completion: @escaping ([Recipe]) -> Void) {
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
