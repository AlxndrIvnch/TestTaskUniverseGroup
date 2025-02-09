//
//  AllItemsVMTests.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/9/25.
//

import Testing
@testable import TestTaskUniverseGroup
import Foundation

struct AllItemsVMTests {
    
    private let fakeStore = ItemsStoreMock()
    
    @Test
    func testCreateSnapshotContainsAllItems() async {
        let items = [
            Item(id: 1, title: "Item 1", isFavorite: false),
            Item(id: 2, title: "Item 2", isFavorite: true)
        ]
        await fakeStore.setItems(items)
        
        let vm = await AllItemsVM(itemsStore: fakeStore)
        try? await Task.sleep(for: .milliseconds(100))
        
        let snapshot = await vm.createSnapshot()
        #expect(snapshot.numberOfItems == items.count, "Snapshot should contain all items")
    }
    
    @Test
    func testToggleItemIsFavorite() async {
        let initialItem = Item(id: 1, title: "Item 1", isFavorite: false)
        await fakeStore.setItems([initialItem])
        
        let vm = await AllItemsVM(itemsStore: fakeStore)
        try? await Task.sleep(for: .milliseconds(100))
        
        await vm.toggleItemIsFavorite(at: IndexPath(row: 0, section: 0))
        
        let updatedItem = await fakeStore.items[0]
        #expect(updatedItem.isFavorite, "Item should be marked as favorite")
    }
}
