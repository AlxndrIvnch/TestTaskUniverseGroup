//
//  DependencyContainer.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/8/25.
//

import Foundation

final class DependencyContainer {
    
    let dataService: DataServiceProtocol
    let itemsRepository: ItemsRepositoryProtocol

    init(dataService: DataServiceProtocol, itemsRepository: ItemsRepositoryProtocol) {
        self.dataService = dataService
        self.itemsRepository = itemsRepository
    }
}
