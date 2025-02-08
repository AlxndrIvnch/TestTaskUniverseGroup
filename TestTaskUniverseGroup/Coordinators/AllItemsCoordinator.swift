//
//  AllItemsCoordinator.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/8/25.
//

import UIKit

@MainActor
final class AllItemsCoordinator {
    
    private let moduleFactory: ModuleFactoryProtocol
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController, moduleFactory: ModuleFactoryProtocol) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }
    
    func start() {
        let allItemsVC = moduleFactory.makeAllItemsVC()
        navigationController?.viewControllers = [allItemsVC]
    }
}
