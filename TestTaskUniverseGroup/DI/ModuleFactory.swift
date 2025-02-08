//
//  ModuleFactory.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/8/25.
//

import UIKit

@MainActor
protocol ModuleFactoryProtocol {
    func makeSplashVC(onLoadedData: @escaping EmptyClosure) -> UIViewController
    func makeAllItemsVC() -> UIViewController
    func makeFavoriteItemsVC() -> UIViewController
}

final class ModuleFactory: ModuleFactoryProtocol {
    
    private let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    func makeSplashVC(onLoadedData: @escaping EmptyClosure) -> UIViewController {
        let splashVM = SplashVM(dataService: container.dataService,
                                itemsRepository: container.itemsRepository,
                                onLoadedData: onLoadedData )
        return SplashVC(viewModel: splashVM)
    }
    
    func makeAllItemsVC() -> UIViewController {
        let allItemsVM = AllItemsVM(itemsRepository: container.itemsRepository)
        return ItemsVC(viewModel: allItemsVM)
    }
    
    func makeFavoriteItemsVC() -> UIViewController {
        let favoriteItemsVM = FavoriteItemsVM(itemsRepository: container.itemsRepository)
        return ItemsVC(viewModel: favoriteItemsVM)
    }
}
