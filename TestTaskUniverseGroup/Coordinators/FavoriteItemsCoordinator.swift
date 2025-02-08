//
//  FavoriteItemsCoordinator.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/8/25.
//

import UIKit

@MainActor
final class FavoriteItemsCoordinator {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let favoriteItemsVM = FavoriteItemsVM(itemsRepository: ItemsRepository.shared)
        let favoriteItemsVC = ItemsVC(viewModel: favoriteItemsVM)
        navigationController?.viewControllers = [favoriteItemsVC]
    }
}
