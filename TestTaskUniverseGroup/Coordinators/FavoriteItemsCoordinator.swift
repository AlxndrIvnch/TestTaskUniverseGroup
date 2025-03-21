//
//  FavoriteItemsCoordinator.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/8/25.
//

import UIKit
import RxSwift

final class FavoriteItemsCoordinator: BaseCoordinator<Never> {
    
    private let moduleFactory: ModuleFactoryProtocol
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController, moduleFactory: ModuleFactoryProtocol) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }
    
    override func start() -> Observable<Never> {
        let (favoriteItemsVC, favoriteItemsVM) = moduleFactory.makeFavoriteItemsModule()
        navigationController?.viewControllers = [favoriteItemsVC]
        // potentially do bindings with favoriteItemsVM.output
        return .never()
    }
}
