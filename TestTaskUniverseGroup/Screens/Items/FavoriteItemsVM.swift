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
    
    var title: String { "Favorite Items" }
    var showMarkFavoriteButton: Bool { false }
    var showRemoveFromFavoriteButton: Bool { true }
    var textWhenEmpty: String { "No favorites yet. Tap an item to mark it as a favorite." }
    
    private let itemsRepository: ItemsRepositoryProtocol
    
    private var favoriteItems = [Item]()
    private var repositoryFetchTask: Task<Void, Never>?
    
    init(itemsRepository: ItemsRepositoryProtocol) {
        self.itemsRepository = itemsRepository
        repositoryFetchTask = Task {
            for await items in await itemsRepository.updates {
                favoriteItems = items.filter(\.isFavorite)
                onUpdateUI?()
            }
        }
    }
    
    deinit {
        repositoryFetchTask?.cancel()
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
        await itemsRepository.markItems(with: ids, asFavorite: asFavorite)
        onLoading?(false)
    }
    
    func toggleItemIsFavorite(at indexPath: IndexPath) async {
        await markItems(at: [indexPath], asFavorite: false)
    }
    
    func getLeadingSwipeActions(for indexPath: IndexPath) -> [SwipeActionVM]? {
        let actionVM = SwipeActionVM(title: "Remove from favorites") { [weak self] completion in
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
