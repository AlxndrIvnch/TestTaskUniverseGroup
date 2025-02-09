//
//  ItemsLoaderTests.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/9/25.
//

import Testing
@testable import TestTaskUniverseGroup

@MainActor
final class ItemsLoaderTests {
    
    private let itemsLoader = ItemsLoader()
    private var progress = 0.0
    
    @Test(.timeLimit(.minutes(1)))
    func testLoadItemsProgressAndResult() async throws {
        let items = try await itemsLoader.loadItems { [weak self] newProgress in
            Task { @MainActor in
                self?.progress = newProgress
            }
        }
        #expect(items.count >= 20, "Minimum items count is 20")
        #expect(progress == 1, "Final progress value should be 1")
    }
}
