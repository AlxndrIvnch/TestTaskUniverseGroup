//
//  TabBarCoordinator.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import UIKit

@MainActor
final class TabBarCoordinator {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let tabBarController = UITabBarController()
        
        let allItemsVM = AllItemsVM(itemsRepository: ItemsRepository.shared)
        let allItemsVC = ItemsVC(viewModel: allItemsVM)
        let allItemsNC = UINavigationController(rootViewController: allItemsVC)
        allItemsNC.tabBarItem = UITabBarItem(title: "All",
                                             image: UIImage(systemName: "list.bullet"),
                                             tag: 0)
        
        let favoriteItemsVM = FavoriteItemsVM(itemsRepository: ItemsRepository.shared)
        let favoriteItemsVC = ItemsVC(viewModel: favoriteItemsVM)
        let favoriteItemsNC = UINavigationController(rootViewController: favoriteItemsVC)
        favoriteItemsNC.tabBarItem = UITabBarItem(title: "Favorites",
                                                  image: UIImage(systemName: "star.fill"),
                                                  tag: 1)
        
        tabBarController.viewControllers = [allItemsNC, favoriteItemsNC]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
