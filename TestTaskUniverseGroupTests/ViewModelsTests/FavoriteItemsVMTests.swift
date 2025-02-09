//
//  FavoriteItemsVMTests.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/9/25.
//

import Testing
@testable import TestTaskUniverseGroup
import Foundation

final class FavoriteItemsVMTests {
    
    private let fakeStore = ItemsStoreMock()
    
    @Test
    func testCreateSnapshotContainsOnlyFavoriteItems() async {
        let items = [
            Item(id: 1, title: "Item 1", isFavorite: false),
            Item(id: 2, title: "Item 2", isFavorite: true)
        ]
        await fakeStore.setItems(items)
        
        let vm = await FavoriteItemsVM(itemsStore: fakeStore)
        try? await Task.sleep(for: .milliseconds(100))
        
        let snapshot = await vm.createSnapshot()
        let favoriteItems = items.filter(\.isFavorite)
        #expect(snapshot.numberOfItems == favoriteItems.count, "Snapshot should contain only favorite items")
    }
    
    @Test
    func testToggleItemIsFavoriteRemovesFavorite() async {
        let initialItem = Item(id: 1, title: "Item 1", isFavorite: true)
        await fakeStore.setItems([initialItem])
        
        let vm = await FavoriteItemsVM(itemsStore: fakeStore)
        try? await Task.sleep(for: .milliseconds(100))
        
        await vm.toggleItemIsFavorite(at: IndexPath(row: 0, section: 0))
        
        let updatedItem = await fakeStore.items[0]
        #expect(!updatedItem.isFavorite, "Item should be removed from favorites")
    }
}
