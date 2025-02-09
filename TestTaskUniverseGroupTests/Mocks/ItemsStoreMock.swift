//
//  ItemsStoreMock.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/9/25.
//

@testable import TestTaskUniverseGroup

actor ItemsStoreMock: ItemsStoreProtocol {
    
    private(set) var items: [Item] = []
    
    var updates: AsyncStream<[Item]> {
        AsyncStream { $0.yield(items) }
    }
    
    func setItems(_ items: [Item]) {
        self.items = items
    }
    
    func markItems(with ids: [Int], asFavorite: Bool) {
        items = items.map { item in
            ids.contains(item.id) ? Item(id: item.id, title: item.title, isFavorite: asFavorite) : item
        }
    }
}
