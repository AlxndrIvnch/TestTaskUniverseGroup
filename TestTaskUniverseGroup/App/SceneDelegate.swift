//
//  SceneDelegate.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let container = DependencyContainer(itemsLoader: ItemsLoader(), itemsStore: ItemsStore())
        let factory = ModuleFactory(container: container)
        appCoordinator = AppCoordinator(window: window, moduleFactory: factory)
        appCoordinator?.start()
    }
}
