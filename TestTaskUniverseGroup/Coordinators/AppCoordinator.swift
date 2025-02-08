//
//  AppCoordinator.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

//protocol Coordinator {
//    var childCoordinators: [Coordinator] { get set }
//    func start()
//}

import UIKit

@MainActor
final class AppCoordinator {
    
    private let moduleFactory: ModuleFactoryProtocol
    private let window: UIWindow

    init(window: UIWindow, moduleFactory: ModuleFactoryProtocol) {
        self.window = window
        self.moduleFactory = moduleFactory
    }
    
    func start() {
        showSplashScreen(onLoadedData: showMainFlow)
    }

    private func showSplashScreen(onLoadedData: @escaping EmptyClosure) {
        let splashVC = moduleFactory.makeSplashVC(onLoadedData: onLoadedData)
        window.rootViewController = splashVC
        window.makeKeyAndVisible()
    }
    
    private func showMainFlow() {
        let tabBarCoordinator = TabBarCoordinator(window: window, moduleFactory: moduleFactory)
        tabBarCoordinator.start()
    }
}
