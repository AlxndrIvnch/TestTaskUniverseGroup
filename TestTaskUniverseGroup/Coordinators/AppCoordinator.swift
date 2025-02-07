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

import UIKit.UIWindow

@MainActor
final class AppCoordinator {
    
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let splashVM = SplashVM(onLoaded: showMainScreen)
        let splashVC = SplashVC(viewModel: splashVM)
        window.rootViewController = splashVC
        window.makeKeyAndVisible()
    }
    
    private func showMainScreen(with data: [String]) {
        debugPrint("Show Main")
    }
}
