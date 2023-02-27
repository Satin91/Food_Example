//
//  RecipesWebRepository.swift
//  Food_Example
//
//  Created by Артур Кулик on 24.01.2023.
//

import Combine
import FirebaseDatabase
import Foundation
import RealmSwift

protocol RecipesApiRepository {
    func searchRecipesBy(params: RecipesRequestParams, path: APIEndpoint) -> Future<List<Recipe>, Never>
    func getRecipeBy(id: Int) -> Future<Recipe, Never>
    func getRecipesBy(ids: [Int]) -> Future<List<Recipe>, Never>
    func showRandomRecipes() -> Future<List<Recipe>, Never>
}

class RecipesApiRepositoryImpl: RecipesApiRepository {
    var cancelBag = Set<AnyCancellable>()
    
    func getRecipeBy(id: Int) -> Future<Recipe, Never> {
        let recipeInfoDispatchGroup = DispatchGroup()
        var recipe: Recipe?
        var nutritients: Nutrient?
        var ingridients: RealmSwift.List<Ingredient>?
        return Future { [weak self] promise in
            guard let self else { return }
            recipeInfoDispatchGroup.enter()
            self.searchRequest(
                model: Recipe.self,
                params: RecipesRequestParams(urlParams: [:]).URLParams,
                path: .recipeInfo(id)
            )
            .sink(receiveCompletion: { error in
                print(error)
                return
            }, receiveValue: { receiveValue in
                recipe = receiveValue
                recipeInfoDispatchGroup.leave()
            })
            .store(in: &self.cancelBag)
            recipeInfoDispatchGroup.enter()
            self.searchRequest(
                model: Nutrient.self,
                params: RecipesRequestParams(urlParams: [:]).URLParams,
                path: .nutritions(id)
            )
            .sink(receiveCompletion: { error in
                print(error)
                return
            }, receiveValue: { receiveValue in
                nutritients = receiveValue
                recipeInfoDispatchGroup.leave()
            })
            .store(in: &self.cancelBag)
            recipeInfoDispatchGroup.enter()
            self.searchRequest(
                model: IngredientWrapper.self,
                params: RecipesRequestParams(urlParams: [:]).URLParams,
                path: .ingridients(id)
            )
            .sink(receiveCompletion: { error in
                print(error)
                return
            }, receiveValue: { receiveValue in
                ingridients = receiveValue.ingredients
                recipeInfoDispatchGroup.leave()
            })
            .store(in: &self.cancelBag)
            recipeInfoDispatchGroup.notify(queue: .main) {
                guard let recipe, let nutritients, let ingridients else { return }
                recipe.nutrients = nutritients
                recipe.ingredients = ingridients
                promise(.success(recipe))
            }
        }
    }
    
    func getRecipesBy(ids: [Int]) -> Future<List<Recipe>, Never> {
        Future { promise in
            let dispatchGroup = DispatchGroup()
            let recipes = List<Recipe>()
            for id in ids {
                dispatchGroup.enter()
                self.getRecipeBy(id: id)
                    .sink { recipe in
                        print("Debug: receive recipe \(id)")
                        recipes.append(recipe)
                        dispatchGroup.leave()
                    }
                    .store(in: &self.cancelBag)
            }
            dispatchGroup.notify(queue: .main) {
                promise(.success(recipes))
            }
        }
    }
    
    func searchRecipesBy(params: RecipesRequestParams, path: APIEndpoint) -> Future<List<Recipe>, Never> {
        Future { promise in
            switch path {
            case .searchInAll:
                self.searchRequest(model: SearchRecipesWrapper.self, params: params.URLParams, path: .searchInAll)
                    .sink { error in
                        print(error)
                    } receiveValue: { recipesWrapper in
                        promise(.success(recipesWrapper.results))
                    }
                    .store(in: &self.cancelBag)
            default:
                self.searchRequest(model: RealmSwift.List<Recipe>.self, params: params.URLParams, path: path)
                    .sink { error in
                        print(error)
                    } receiveValue: { recipes in
                        promise(.success(recipes))
                    }
                    .store(in: &self.cancelBag)
            }
        }
    }
    
    func showRandomRecipes() -> Future<List<Recipe>, Never> {
        Future { promise in
            self.searchRequest(
                model: SearchRecipesWrapper.self,
                params: RecipesRequestParams(urlParams: [:]).URLParams,
                path: .randomRecipes
            )
            .sink { error in
                print(error)
            } receiveValue: { recipeWrapper in
                promise(.success(recipeWrapper.recipes))
            }
            .store(in: &self.cancelBag)
        }
    }
}

extension RecipesApiRepository {
    func searchRequest<T: Decodable>(model: T.Type, params: [String: String], path: APIEndpoint) -> AnyPublisher<T, Error> {
        guard var url = URL(string: Constants.API.baseURL + path.path) else {
            return Fail(outputType: model, failure: APIRequestError.invalidURL).eraseToAnyPublisher()
        }
        url = url.appendingQueryParameters(params)
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: model.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
