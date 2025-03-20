//
//  AllItemsCoordinator.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/8/25.
//

import UIKit
import RxSwift

final class AllItemsCoordinator: BaseCoordinator<Never> {
    
    private let moduleFactory: ModuleFactoryProtocol
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController, moduleFactory: ModuleFactoryProtocol) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }
    
    override func start() -> Observable<Never> {
        let (allItemsVC, allItemsVM) = moduleFactory.makeAllItemsModule()
        navigationController?.viewControllers = [allItemsVC]
        // potentially do bindings with allItemsVM.output
        return .never()
    }
}
