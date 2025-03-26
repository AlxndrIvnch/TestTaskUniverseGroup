//
//  SceneDelegate.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import UIKit
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
       
    private let disposeBag = DisposeBag()
    
    private var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print(1)
        print(2)
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let container = DependencyContainer(itemsLoader: ItemsLoader(), itemsStore: ItemsStore())
        let factory = ModuleFactory(container: container)
        appCoordinator = AppCoordinator(window: window, moduleFactory: factory)
        appCoordinator?.start()
            .subscribe()
            .disposed(by: disposeBag)
    }
}
