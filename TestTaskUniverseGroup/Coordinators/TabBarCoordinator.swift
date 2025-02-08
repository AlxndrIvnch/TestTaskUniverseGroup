//
//  TabBarCoordinator.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import UIKit

@MainActor
final class TabBarCoordinator {
    
    private let moduleFactory: ModuleFactoryProtocol
    
    private weak var window: UIWindow?
    
    init(window: UIWindow, moduleFactory: ModuleFactoryProtocol) {
        self.window = window
        self.moduleFactory = moduleFactory
    }
    
    func start() {
        let tabBarController = UITabBarController()
        
        let allItemsNC = UINavigationController()
        allItemsNC.tabBarItem = UITabBarItem(title: String(localized: "all_items_tab_name"),
                                             image: UIImage(systemName: "list.bullet"),
                                             tag: 0)
        let allItemsCoordinator = AllItemsCoordinator(navigationController: allItemsNC,
                                                      moduleFactory: moduleFactory)
        allItemsCoordinator.start()
        
        let favoriteItemsNC = UINavigationController()
        favoriteItemsNC.tabBarItem = UITabBarItem(title: String(localized: "favorite_items_tab_name"),
                                                  image: UIImage(systemName: "star.fill"),
                                                  tag: 1)
        let favoriteItemsCoordinator = FavoriteItemsCoordinator(navigationController: favoriteItemsNC,
                                                                moduleFactory: moduleFactory)
        favoriteItemsCoordinator.start()
       
        
        tabBarController.viewControllers = [allItemsNC, favoriteItemsNC]
        
        window?.setRootViewController(tabBarController)
    }   
}
