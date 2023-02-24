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
    func showRandomRecipes()
    func searchRecipesBy(params: RecipesRequestParams, path: APIEndpoint)
    func getRecipeInfoBy(id: Int) -> Future<Recipe, Never>
    func getRecipesInfoBy(ids: [Int])
    func saveSeveralRecipes(_ recipes: RealmSwift.List<Recipe>)
    func saveSingleRecipe(_ recipe: Recipe)
    func removeFavorite(index: Int)
}

class RecipesInteractorImpl: RecipesInteractor {
    let recipesWebRepository: RecipesWebRepository
    let dbRepository: DBRepository
    let searchRecipesDispatchGroup = DispatchGroup()
    
    var cancelBag = Set<AnyCancellable>()
    let dispatchGroup = DispatchGroup()
    var appState: Store<AppState>
    let imageLoader = ImageLoader()
    
    init(recipesWebRepository: RecipesWebRepository, dbRepository: DBRepository, appState: Store<AppState>) {
        self.recipesWebRepository = recipesWebRepository
        self.dbRepository = dbRepository
        self.appState = appState
        self.appState.sinkToStorage(dbRepository)
    }
    
    // MARK: WEB
    func searchRecipesBy(params: RecipesRequestParams, path: APIEndpoint) {
        switch path {
        case .searchInAll:
            getRecipeInfo(model: SearchRecipesWrapper.self, params: params.URLParams, path: .searchInAll, id: 0) { result in
                switch result {
                case .success(let wrapper):
                    wrapper.results.forEach { self.imageLoader.downloadImage(urlString: $0.image) }
                    self.appState.value.searchableRecipes = wrapper.results
                    print("Searchable recipes search finished")
                case .failure(let failure):
                    print(failure)
                }
            }
        default:
            getRecipeInfo(model: RealmSwift.List<Recipe>.self, params: params.URLParams, path: path, id: 0) { [weak self] result in
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
        var nutritients: Nutrient?
        var ingridients: RealmSwift.List<Ingredient>?
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
                    print("recipe received value")
                    recipe = receiveValue
                case .failure:
                    fatalError("Failed to get info 1")
                }
            }
            self.getRecipeInfo(
                model: Nutrient.self,
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
                guard let resultRecipe = recipe else {
                    fatalError("Failed to get info 3")
                }
                resultRecipe.nutrients = nutritients
                resultRecipe.ingredients = ingridients!
                promise(.success(resultRecipe))
            }
        }
    }
    
    func loadMainImage(urlString: String) {
        dispatchGroup.enter()
        imageLoader.downloadImage(urlString: urlString)
        dispatchGroup.leave()
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
            case .success(let wrapper):
                self.appState.value.searchableRecipes.append(objectsIn: wrapper.recipes)
            case .failure(let failure):
                print("Failure getting random recipes \(failure.localizedDescription)")
            }
        }
    }
    
    // MARK: DataBase
    func saveSeveralRecipes(_ recipes: RealmSwift.List<Recipe>) {
        dbRepository.save(favoriteRecipes: recipes)
    }
    
    func saveSingleRecipe(_ recipe: Recipe) {
        dbRepository.save(favoriteRecipe: recipe)
    }
    
    func removeFavorite(index: Int) {
        dbRepository.removeFavorite(from: index)
    }
    
    func getRecipesInfoBy(ids: [Int]) {
        var recipes: [Recipe] = []
        ids.forEach { id in
            searchRecipesDispatchGroup.enter()
            getRecipeInfoBy(id: id)
                .sink { recipe in
                    recipes.append(recipe)
                    self.searchRecipesDispatchGroup.leave()
                }
                .store(in: &cancelBag)
        }
        searchRecipesDispatchGroup.notify(queue: .main) {
            let recipesRealm = RealmSwift.List<Recipe>()
            recipesRealm.append(objectsIn: recipes)
            self.dbRepository.save(favoriteRecipes: recipesRealm)
        }
    }
}

struct StubRecipesInteractor: RecipesInteractor {
    var storage = UserRealm()
    
    func searchRecipesBy(params: RecipesRequestParams, path: APIEndpoint) {
    }
    
    func getRecipeInfoBy(id: Int) -> Future<Recipe, Never> {
        Future { _ in
        }
    }
    
    func showRandomRecipes() {
    }
    
    func saveSeveralRecipes(_ recipe: RealmSwift.List<Recipe>) {
    }
    
    func removeFavorite(index: Int) {
    }
    
    func getRecipesInfoBy(ids: [Int]) {
    }
    
    func saveSingleRecipe(_ recipe: Recipe) {
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
