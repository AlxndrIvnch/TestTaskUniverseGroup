//
//  AllItemsCoordinator.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/8/25.
//

import UIKit

@MainActor
final class AllItemsCoordinator {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let allItemsVM = AllItemsVM(itemsRepository: ItemsRepository.shared)
        let allItemsVC = ItemsVC(viewModel: allItemsVM)
        navigationController?.viewControllers = [allItemsVC]
    }
}
