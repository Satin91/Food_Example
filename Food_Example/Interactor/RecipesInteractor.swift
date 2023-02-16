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
    
    func showRandomRecipes()
    func searchRecipesBy(params: RecipesRequestParams, path: APIEndpoint)
    func getRecipeInfoBy(id: Int) -> Future<Recipe, Never>
    func getRecipesInfoBy(ids: [Int])
    func saveUserToStorage(userInfo: RemoteUserInfo, favoriteRecipes: [Recipe])
    func saveFavorite(recipe: RecipeRealm)
    func removeFavorite(index: Int)
}

class RecipesInteractorImpl: RecipesInteractor {
    var recipesWebRepository: RecipesWebRepository
    var recipesDBRepository: RecipesDBRepository
    var cancelBag = Set<AnyCancellable>()
    let dispatchGroup = DispatchGroup()
    let searchRecipesDispatchGroup = DispatchGroup()
    var appState: Store<AppState>
    @ObservedRealmObject var storage: UserRealm
    let imageLoader = ImageLoader()
    
    init(recipesWebRepository: RecipesWebRepository, recipesDBRepository: RecipesDBRepository, appState: Store<AppState>) {
        self.recipesWebRepository = recipesWebRepository
        self.recipesDBRepository = recipesDBRepository
        self.appState = appState
        self.storage = recipesDBRepository.storage[2]
    }
    
    // MARK: WEB
    func searchRecipesBy(params: RecipesRequestParams, path: APIEndpoint) {
        switch path {
        case .searchInAll:
            getRecipeInfo(model: SearchRecipesWrapper.self, params: params.URLParams, path: .searchInAll, id: 0) { result in
                switch result {
                case .success(let wrapper):
                    wrapper.results?.forEach { self.imageLoader.downloadImage(urlString: $0.image) }
                    self.appState.value.searchableRecipes = wrapper.results ?? []
                case .failure(let failure):
                    print(failure)
                }
            }
        default:
            getRecipeInfo(model: [Recipe].self, params: params.URLParams, path: path, id: 0) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let recipes):
                    recipes.forEach { self.imageLoader.downloadImage(urlString: $0.image) }
                    self.appState.value.searchableRecipes = recipes
                case .failure(let failure):
                    print(failure)
                }
            }
        }
    }
    
    func getRecipeInfoBy(id: Int) -> Future<Recipe, Never> {
        var recipe: Recipe?
        var nutritients: Nutritient?
        var ingridients: [Ingredient]?
        return Future { [weak self] promise in
            guard let self else { return }
            self.getRecipeInfo(
                model: Recipe.self,
                params: RecipesRequestParams(urlParams: [:]).URLParams,
                path: .recipeInfo(id),
                id: id
            ) { result in
                switch result {
                case .success(let receiveValue):
                    recipe = receiveValue
                case .failure:
                    fatalError("Failed to get info 1")
                }
            }
            self.getRecipeInfo(
                model: Nutritient.self,
                params: RecipesRequestParams(urlParams: [:]).URLParams,
                path: .nutritions(id),
                id: id
            ) { result in
                switch result {
                case .success(let receiveValue):
                    nutritients = receiveValue
                case .failure:
                    fatalError("Failed to get info 2")
                }
            }
            self.getRecipeInfo(
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
            self.dispatchGroup.notify(queue: .main) {
                guard var recipe = recipe else {
                    fatalError("Failed to get info 3")
                }
                recipe.nutrients = nutritients
                recipe.ingridients = ingridients
                promise(.success(recipe))
            }
        }
    }
    
    func showRandomRecipes() {
        let urlParams = RecipesRequestParams(urlParams: [:]).URLParams
        getRecipeInfo(
            model: SearchRecipesWrapper.self,
            params: urlParams,
            path: .randomRecipes,
            id: 0
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.appState.value.searchableRecipes = success.recipes ?? []
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
    
    func getRecipesInfoBy(ids: [Int]) {
        var recipes: [Recipe] = []
        ids.forEach { id in
            searchRecipesDispatchGroup.enter()
            print("enter dispatchgroup")
            getRecipeInfoBy(id: id)
                .sink { recipe in
                    recipes.append(recipe)
                    self.searchRecipesDispatchGroup.leave()
                }
                .store(in: &cancelBag)
        }
        searchRecipesDispatchGroup.notify(queue: .main) {
            print("notify")
            self.appState.value.userRecipes.append(objectsIn: recipes.map { RecipeRealm(recipe: $0) })
        }
    }
    
    func saveUserToStorage(userInfo: RemoteUserInfo, favoriteRecipes: [Recipe]) {
        recipesDBRepository.saveUserToStorage(userInfo: userInfo, favoriteRecipes: favoriteRecipes)
    }
}

struct StubRecipesInteractor: RecipesInteractor {
    var storage = UserRealm()
    
    func saveUserToStorage(userInfo: RemoteUserInfo, favoriteRecipes: [Recipe]) {
    }
    
    func searchRecipesBy(params: RecipesRequestParams, path: APIEndpoint) {
    }
    
    func getRecipeInfoBy(id: Int) -> Future<Recipe, Never> {
        Future { promise in
            promise(.success(Recipe(id: 0, title: "", image: "")))
        }
    }
    
    func showRandomRecipes() {
    }
    
    func saveFavorite(recipe: RecipeRealm) {
    }
    
    func removeFavorite(index: Int) {
    }
    
    func getRecipesInfoBy(ids: [Int]) {
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
