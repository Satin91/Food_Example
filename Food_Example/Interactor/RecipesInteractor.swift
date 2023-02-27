//
//  RecipesInteractor.swift
//  Food_Example
//
//  Created by Артур Кулик on 23.01.2023.
//

import Combine
import RealmSwift

protocol RecipesInteractor {
    func showRandomRecipes()
    func searchRecipesBy(params: RecipesRequestParams, path: APIEndpoint)
    func getRecipeInfoBy(id: Int, completion: @escaping (Recipe) -> Void)
    func getRecipesInfoBy(ids: [Int])
    func saveSeveralRecipes(_ recipes: List<Recipe>)
    func saveSingleRecipe(_ recipe: Recipe)
    func removeFavorite(index: Int)
}

class RecipesInteractorImpl: RecipesInteractor {
    let recipesApiRepository: RecipesApiRepository
    let localRepository: LocalRepository
    let remoteRepository: RemoteRepository
    let searchRecipesDispatchGroup = DispatchGroup()
    
    var cancelBag = Set<AnyCancellable>()
    let dispatchGroup = DispatchGroup()
    var appState: Store<AppState>
    let imageLoader = ImageLoader()
    
    init(recipesApiRepository: RecipesApiRepository, localRepository: LocalRepository, remoteRepository: RemoteRepository, appState: Store<AppState>) {
        self.recipesApiRepository = recipesApiRepository
        self.localRepository = localRepository
        self.remoteRepository = remoteRepository
        self.appState = appState
        self.appState.sinkToStorage(localRepository)
    }
    
    // MARK: WEB
    func searchRecipesBy(params: RecipesRequestParams, path: APIEndpoint) {
        self.recipesApiRepository.searchRecipesBy(params: params, path: path)
            .sink { recipes in
                print("searh recipes by params \(recipes.map { $0.title })")
                self.appState.value.searchableRecipes = recipes
            }
            .store(in: &cancelBag)
    }
    
    func getRecipeInfoBy(id: Int, completion: @escaping (Recipe) -> Void) {
        recipesApiRepository.getRecipeInfoBy(id: id)
            .sink { recipe in
                completion(recipe)
            }
            .store(in: &cancelBag)
    }
    
    func loadMainImage(urlString: String) {
        dispatchGroup.enter()
        imageLoader.downloadImage(urlString: urlString)
        dispatchGroup.leave()
    }
    
    func showRandomRecipes() {
        recipesApiRepository.showRandomRecipes()
            .sink { recipes in
                self.appState.value.searchableRecipes = recipes
            }
            .store(in: &cancelBag)
    }
    
    // MARK: DataBase
    func saveSeveralRecipes(_ recipes: RealmSwift.List<Recipe>) {
        localRepository.save(favoriteRecipes: recipes)
        updateRemoteStorage()
    }
    
    func saveSingleRecipe(_ recipe: Recipe) {
        localRepository.save(favoriteRecipe: recipe)
        updateRemoteStorage()
    }
    
    func removeFavorite(index: Int) {
        localRepository.removeFavorite(from: index)
        updateRemoteStorage()
    }
    
    func getRecipesInfoBy(ids: [Int]) {
        self.recipesApiRepository.getRecipesInfoBy(ids: ids)
            .sink { recipes in
                self.localRepository.save(favoriteRecipes: recipes)
            }
            .store(in: &cancelBag)
    }
}

struct StubRecipesInteractor: RecipesInteractor {
    var storage = UserRealm()
    
    func searchRecipesBy(params: RecipesRequestParams, path: APIEndpoint) {
    }
    
    func getRecipeInfoBy(id: Int, completion: @escaping (Recipe) -> Void) {
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
    private func updateRemoteStorage() {
        let uid = appState.value.user.uid
        let recipes = localRepository.storagePublisher.value.favoriteRecipes
        self.remoteRepository.publish(recipe: recipes, uid: uid)
    }
}
