//
//  ModuleFactory.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/8/25.
//

import UIKit

protocol ModuleFactoryProtocol {
    func makeSplashModule() -> (vc: SplashVC, vm: SplashVM)
    func makeAllItemsModule() -> (vc: ItemsVC, vm: AllItemsVM)
    func makeFavoriteItemsModule() -> (vc: ItemsVC, vm: FavoriteItemsVM)
}

final class ModuleFactory: ModuleFactoryProtocol {
    
    private let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    func makeSplashModule() -> (vc: SplashVC, vm: SplashVM) {
        let splashVM = SplashVM(itemsLoader: container.itemsLoader,
                                itemsStore: container.itemsStore)
        let splashVC = SplashVC(viewModel: splashVM)
        return (splashVC, splashVM)
    }
    
    func makeAllItemsModule() -> (vc: ItemsVC, vm: AllItemsVM) {
        let allItemsVM = AllItemsVM(itemsStore: container.itemsStore)
        let allItemsVC = ItemsVC(viewModel: allItemsVM)
        return (allItemsVC, allItemsVM)
    }
    
    func makeFavoriteItemsModule() -> (vc: ItemsVC, vm: FavoriteItemsVM) {
        let favoriteItemsVM = FavoriteItemsVM(itemsStore: container.itemsStore)
        let favoriteItemsVC = ItemsVC(viewModel: favoriteItemsVM)
        return (favoriteItemsVC, favoriteItemsVM)
    }
}
