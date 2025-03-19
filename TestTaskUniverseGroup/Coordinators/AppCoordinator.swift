//
//  AppCoordinator.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import UIKit

final class AppCoordinator {
    
    private let moduleFactory: ModuleFactoryProtocol
    private let window: UIWindow

    init(window: UIWindow, moduleFactory: ModuleFactoryProtocol) {
        self.window = window
        self.moduleFactory = moduleFactory
    }
    
    func start() {
        showSplashScreen(onLoadedItems: showMainFlow)
    }

    private func showSplashScreen(onLoadedItems: @escaping EmptyClosure) {
        let splashVC = moduleFactory.makeSplashVC(onLoadedItems: onLoadedItems)
        window.rootViewController = splashVC
        window.makeKeyAndVisible()
    }
    
    private func showMainFlow() {
        let tabBarCoordinator = TabBarCoordinator(window: window, moduleFactory: moduleFactory)
        tabBarCoordinator.start()
    }
}
