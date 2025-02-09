//
//  ItemsLoaderTests.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/9/25.
//

import Testing
@testable import TestTaskUniverseGroup

struct ItemsLoaderTests {
    
    private let itemsLoader = ItemsLoader()
    
    @Test(.timeLimit(.minutes(1)))
    func testLoadItemsProgressAndResult() async throws {
        var progress = 0.0
        
        let items = try await itemsLoader.loadItems { newProgress in
            Task { @MainActor in
                progress = newProgress
            }
        }
        #expect(items.count >= 20, "Minimum items count is 20")
        #expect(progress == 1, "Final progress value should be 1")
    }
}
