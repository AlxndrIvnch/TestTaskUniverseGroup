//
//  AppCoordinator.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import UIKit
import RxSwift

final class AppCoordinator: BaseCoordinator<Never> {
    
    private let moduleFactory: ModuleFactoryProtocol
    private let window: UIWindow

    init(window: UIWindow, moduleFactory: ModuleFactoryProtocol) {
        self.window = window
        self.moduleFactory = moduleFactory
    }
    
    override func start() -> Observable<Never> {
        showSplashScreen()
            .flatMap { [unowned self] _ in
                showMainFlow()
            }
            .subscribe()
            .disposed(by: disposeBag)
        return .never()
    }

    private func showSplashScreen() -> Observable<Void> {
        let (splashVC, splashVM) = moduleFactory.makeSplashModule()
        window.rootViewController = splashVC
        window.makeKeyAndVisible()
        return splashVM.output.itemsLoaded.asObservable()
    }
    
    private func showMainFlow() -> Observable<Never> {
        let tabBarCoordinator = TabBarCoordinator(window: window, moduleFactory: moduleFactory)
        return coordinate(to: tabBarCoordinator)
    }
}
