//
//  ItemsLoader.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import Foundation

protocol ItemsLoaderProtocol: Actor {
    func loadItems(progressHandler: (@Sendable (Double) -> Void)?) async throws -> [Item]
}

extension ItemsLoaderProtocol {
    func loadItems() async throws -> [Item] {
        return try await loadItems(progressHandler: nil)
    }
}

actor ItemsLoader: ItemsLoaderProtocol {
    
    func loadItems(progressHandler: (@Sendable (Double) -> Void)? = nil) async throws -> [Item] {
        let duration = 2.0
        let steps = 20
        let sleepInterval = duration / Double(steps)
        for step in 1...steps {
            try await Task.sleep(for: .seconds(sleepInterval), tolerance: .milliseconds(100))
            progressHandler?(Double(step) / Double(steps))
        }
        return (1...100).map { Item(id: $0, title: "Item \($0)", isFavorite: false) }
    }
}
