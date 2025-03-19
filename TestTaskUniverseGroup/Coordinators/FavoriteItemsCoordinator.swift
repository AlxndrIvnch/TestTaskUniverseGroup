//
//  FavoriteItemsCoordinator.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/8/25.
//

import UIKit

final class FavoriteItemsCoordinator {
    
    private let moduleFactory: ModuleFactoryProtocol
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController, moduleFactory: ModuleFactoryProtocol) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }
    
    func start() {
        let favoriteItemsVC = moduleFactory.makeFavoriteItemsVC()
        navigationController?.viewControllers = [favoriteItemsVC]
    }
}
