//
//  TabBarCoordinator.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import UIKit
import RxSwift

final class TabBarCoordinator: BaseCoordinator<Never> {
    
    private let moduleFactory: ModuleFactoryProtocol
    
    private weak var window: UIWindow?
    
    init(window: UIWindow, moduleFactory: ModuleFactoryProtocol) {
        self.window = window
        self.moduleFactory = moduleFactory
    }
    
    override func start() -> Observable<Never> {
        let tabBarController = UITabBarController()
        
        let allItemsNC = UINavigationController()
        allItemsNC.tabBarItem = UITabBarItem(
            title: String(localized: "all_items_tab_name"),
            image: UIImage(systemName: "list.bullet"),
            tag: 0
        )
        
        let favoriteItemsNC = UINavigationController()
        favoriteItemsNC.tabBarItem = UITabBarItem(
            title: String(localized: "favorite_items_tab_name"),
            image: UIImage(systemName: "star.fill"),
            tag: 1
        )
        
        tabBarController.viewControllers = [allItemsNC, favoriteItemsNC]
        
        Observable.merge(
            addAllItemsFlow(on: allItemsNC),
            addFavoriteItemsFlow(on: favoriteItemsNC)
        )
        .subscribe()
        .disposed(by: disposeBag)
        
        window?.setRootViewControllerAnimated(tabBarController)
        
        return .never()
    }
    
    func addAllItemsFlow(on navigationController: UINavigationController) -> Observable<Never> {
        let allItemsCoordinator = AllItemsCoordinator(
            navigationController: navigationController,
            moduleFactory: moduleFactory
        )
        return coordinate(to: allItemsCoordinator)
    }
    
    func addFavoriteItemsFlow(on navigationController: UINavigationController) -> Observable<Never> {
        let favoriteItemsCoordinator = FavoriteItemsCoordinator(
            navigationController: navigationController,
            moduleFactory: moduleFactory
        )
        return coordinate(to: favoriteItemsCoordinator)
    }
}
