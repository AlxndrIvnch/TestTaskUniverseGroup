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
    
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        showSplashScreen(onLoadedData: showMainFlow)
    }

    private func showSplashScreen(onLoadedData: @escaping EmptyClosure) {
        let splashVM = SplashVM(dataService: DataService.shared,
                                itemsRepository: ItemsRepository.shared,
                                onLoadedData: onLoadedData)
        let splashVC = SplashVC(viewModel: splashVM)
        window.rootViewController = splashVC
        window.makeKeyAndVisible()
    }
    
    private func showMainFlow() {
        let tabBarCoordinator = TabBarCoordinator(window: window)
        tabBarCoordinator.start()
    }
}
