//
//  FavoriteItemsVM.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import Foundation
import UIKit.NSDiffableDataSourceSectionSnapshot

final class FavoriteItemsVM: ItemsVMProtocol {
    
    var onUpdateUI: EmptyClosure?
    var onLoading: SimpleClosure<Bool>?
    
    var title: String { String(localized: "favorite_items_screen_title") }
    var showMarkFavoriteButton: Bool { false }
    var showRemoveFromFavoriteButton: Bool { true }
    var textWhenEmpty: String { String(localized: "favorites_empty") }
    
    private let itemsStore: ItemsStoreProtocol
    
    private var favoriteItems = [Item]()
    private var storeFetchTask: Task<Void, Never>?
    
    init(itemsStore: ItemsStoreProtocol) {
        self.itemsStore = itemsStore
        storeFetchTask = Task {
            for await items in await itemsStore.updates {
                favoriteItems = items.filter(\.isFavorite)
                onUpdateUI?()
            }
        }
    }
    
    deinit {
        storeFetchTask?.cancel()
    }
    
    func createSnapshot() -> NSDiffableDataSourceSnapshot<Int, ItemCell.ViewModel> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ItemCell.ViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(favoriteItems.map(ItemCell.ViewModel.init))
        return snapshot
    }
    
    func markItems(at indexPaths: [IndexPath], asFavorite: Bool) async {
        onLoading?(true)
        let ids = indexPaths.compactMap { favoriteItems[safe: $0.row]?.id }
        await itemsStore.markItems(with: ids, asFavorite: asFavorite)
        onLoading?(false)
    }
    
    func toggleItemIsFavorite(at indexPath: IndexPath) async {
        await markItems(at: [indexPath], asFavorite: false)
    }
    
    func getLeadingSwipeActions(for indexPath: IndexPath) -> [SwipeActionVM]? {
        let actionVM = SwipeActionVM(
            title: String(localized: "remove_item_from_favorites"),
            isDestructive: true
        ) { [weak self] completion in
            Task {
                await self?.markItems(at: [indexPath], asFavorite: false)
                completion(true)
            }
        }
        return [actionVM]
    }
    
    func canMarkFavorite(at indexPaths: [IndexPath]) -> Bool {
        return false
    }
    
    func canRemoveFromFavorite(at indexPaths: [IndexPath]) -> Bool {
        return !indexPaths.isEmpty
    }
}
