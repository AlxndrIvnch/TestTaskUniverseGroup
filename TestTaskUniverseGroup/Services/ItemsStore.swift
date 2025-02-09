//
//  ItemsStore.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import Foundation

protocol ItemsStoreProtocol: Actor {
    var items: [Item] { get }
    var updates: AsyncStream<[Item]> { get }
    func setItems(_ items: [Item])
    func markItems(with ids: [Int], asFavorite: Bool)
}

actor ItemsStore: ItemsStoreProtocol {
    
    private(set) var items = [Item]() {
        didSet { continuations.forEach { $0.value.yield(items) } }
    }
    
    var updates: AsyncStream<[Item]> {
        AsyncStream { continuation in
            let id = UUID()
            continuations[id] = continuation
            continuation.onTermination = { [weak self] _ in
                Task {
                    await self?.removeContinuation(with: id)
                }
            }
            continuation.yield(items)
        }
    }
    
    private var continuations = [UUID: AsyncStream<[Item]>.Continuation]()
    
    func setItems(_ items: [Item]) {
        self.items = items
    }
    
    func markItems(with ids: [Int], asFavorite: Bool) {
        var copy = items
        for itemId in ids {
            guard let index = copy.firstIndex(where: { $0.id == itemId }) else { continue }
            copy[safe: index]?.isFavorite = asFavorite
        }
        items = copy
    }
    
    private func removeContinuation(with id: UUID) {
        continuations.removeValue(forKey: id)
    }
}
