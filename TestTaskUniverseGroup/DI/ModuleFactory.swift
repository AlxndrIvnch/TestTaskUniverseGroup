//
//  ModuleFactory.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/8/25.
//

import UIKit

protocol ModuleFactoryProtocol {
    func makeSplashVC(onLoadedItems: @escaping EmptyClosure) -> UIViewController
    func makeAllItemsVC() -> UIViewController
    func makeFavoriteItemsVC() -> UIViewController
}

final class ModuleFactory: ModuleFactoryProtocol {
    
    private let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    func makeSplashVC(onLoadedItems: @escaping EmptyClosure) -> UIViewController {
        let splashVM = SplashVM(itemsLoader: container.itemsLoader,
                                itemsStore: container.itemsStore,
                                onLoadedItems: onLoadedItems)
        return SplashVC(viewModel: splashVM)
    }
    
    func makeAllItemsVC() -> UIViewController {
        let allItemsVM = AllItemsVM(itemsStore: container.itemsStore)
        return ItemsVC(viewModel: allItemsVM)
    }
    
    func makeFavoriteItemsVC() -> UIViewController {
        let favoriteItemsVM = FavoriteItemsVM(itemsStore: container.itemsStore)
        return ItemsVC(viewModel: favoriteItemsVM)
    }
}
