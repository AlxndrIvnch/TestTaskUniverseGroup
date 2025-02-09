//
//  ItemsStoreTests.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/9/25.
//

import Testing
@testable import TestTaskUniverseGroup

@MainActor
final class ItemsStoreTests {
    
    private let itemsStore = ItemsStore()
    private var storeFetchTask: Task<Void, Never>?
    
    @Test
    func testSetItemsAndMarkItems() async {
        let items = [
            Item(id: 1, title: "Item 1", isFavorite: false),
            Item(id: 2, title: "Item 2", isFavorite: false)
        ]
        await itemsStore.setItems(items)
        await itemsStore.markItems(with: [1], asFavorite: true)
        
        storeFetchTask = Task {
            for await updatedItems in await itemsStore.updates {
                #expect(updatedItems.count == items.count)
                #expect(updatedItems.first(where: { $0.id == 1 })?.isFavorite == true, "Item 1 should be marked as favorite")
                #expect(updatedItems.first(where: { $0.id == 2 })?.isFavorite == false, "Item 2 should remain not favorite")
                storeFetchTask?.cancel()
            }
        }
        
        let updatedItems = await itemsStore.items
        #expect(updatedItems.count == items.count)
        #expect(updatedItems.first(where: { $0.id == 1 })?.isFavorite == true, "Item 1 should be marked as favorite")
        #expect(updatedItems.first(where: { $0.id == 2 })?.isFavorite == false, "Item 2 should remain not favorite")
    }
}
