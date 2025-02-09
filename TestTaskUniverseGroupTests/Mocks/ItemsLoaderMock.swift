//
//  ItemsLoaderMock.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/9/25.
//

@testable import TestTaskUniverseGroup

actor ItemsLoaderMock: ItemsLoaderProtocol {
    func loadItems(progressHandler: (@Sendable (Double) -> Void)? = nil) async throws -> [Item] {
        progressHandler?(1.0)
        return [Item(id: 1, title: "Fake Item", isFavorite: false)]
    }
}
