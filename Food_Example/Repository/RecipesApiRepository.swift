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
    func searchRequest<T: Decodable>(model: T.Type, params: [String: String], path: APIEndpoint) -> AnyPublisher<T, Error>
    func searchRecipesBy(params: RecipesRequestParams, path: APIEndpoint) -> Future<List<Recipe>, Never>
    func getRecipeInfoBy(id: Int) -> Future<Recipe, Never>
    func getRecipesInfoBy(ids: [Int]) -> Future<List<Recipe>, Never>
    func showRandomRecipes() -> Future<List<Recipe>, Never>
}

class RecipesApiRepositoryImpl: RecipesApiRepository {
    let recipeInfoDispatchGroup = DispatchGroup()
    let searchRecipesDispatchGroup = DispatchGroup()
    var cancelBag = Set<AnyCancellable>()
    
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
    
    func getRecipeInfoBy(id: Int) -> Future<Recipe, Never> {
        var recipe: Recipe?
        var nutritients: Nutrient?
        var ingridients: RealmSwift.List<Ingredient>?
        return Future { [weak self] promise in
            guard let self else { return }
            self.recipeInfoDispatchGroup.enter()
            self.searchRequest(
                model: Recipe.self,
                params: RecipesRequestParams(urlParams: [:]).URLParams,
                path: .recipeInfo(id)
            )
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { receiveValue in
                self.recipeInfoDispatchGroup.leave()
                recipe = receiveValue
            })
            .store(in: &self.cancelBag)
            self.recipeInfoDispatchGroup.enter()
            self.searchRequest(
                model: Nutrient.self,
                params: RecipesRequestParams(urlParams: [:]).URLParams,
                path: .nutritions(id)
            )
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { receiveValue in
                self.recipeInfoDispatchGroup.leave()
                nutritients = receiveValue
            })
            .store(in: &self.cancelBag)
            self.recipeInfoDispatchGroup.enter()
            self.searchRequest(
                model: IngredientWrapper.self,
                params: RecipesRequestParams(urlParams: [:]).URLParams,
                path: .ingridients(id)
            )
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { receiveValue in
                self.recipeInfoDispatchGroup.leave()
                ingridients = receiveValue.ingredients
            })
            .store(in: &self.cancelBag)
            self.recipeInfoDispatchGroup.notify(queue: .main) {
                guard let recipe, let nutritients, let ingridients else { return }
                recipe.nutrients = nutritients
                recipe.ingredients = ingridients
                promise(.success(recipe))
            }
        }
    }
    
    func getRecipesInfoBy(ids: [Int]) -> Future<List<Recipe>, Never> {
        Future { promise in
            let recipes = List<Recipe>()
            ids.forEach { id in
                self.searchRecipesDispatchGroup.enter()
                self.getRecipeInfoBy(id: id)
                    .sink { recipe in
                        recipes.append(recipe)
                        self.searchRecipesDispatchGroup.leave()
                    }
                    .store(in: &self.cancelBag)
            }
            self.searchRecipesDispatchGroup.notify(queue: .main) {
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
