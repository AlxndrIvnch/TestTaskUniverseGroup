//
//  DependencyContainer.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/8/25.
//

import Foundation

final class DependencyContainer {
    
    let itemsLoader: ItemsLoaderProtocol
    let itemsStore: ItemsStoreProtocol

    init(itemsLoader: ItemsLoaderProtocol, itemsStore: ItemsStoreProtocol) {
        self.itemsLoader = itemsLoader
        self.itemsStore = itemsStore
    }
}
