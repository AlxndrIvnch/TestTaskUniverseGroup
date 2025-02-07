//
//  DataService.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import Foundation

protocol DataServiceProtocol: Actor {
    func loadData() async throws -> [Item]
}

actor DataService: DataServiceProtocol {
    
    static let shared = DataService()
    
    private init() {}
    
    func loadData() async throws -> [Item] {
        try await Task.sleep(for: .seconds(3))
        let items = (1...50).map { Item(id: $0, title: "Item \($0)", isFavorite: false) }
        await ItemsRepository.shared.updateItems(with: items)
        return items
    }
}
