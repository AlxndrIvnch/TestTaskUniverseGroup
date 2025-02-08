//
//  AllItemsVM.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import Foundation
import UIKit.NSDiffableDataSourceSectionSnapshot

final class AllItemsVM: ItemsVMProtocol {
    
    var onUpdateUI: EmptyClosure?
    var onLoading: SimpleClosure<Bool>?
    
    var title: String { "All Items" }
    var showRemoveFromFavoriteButton: Bool { true }
    var showMarkFavoriteButton: Bool { true }
    
    private let itemsRepository: ItemsRepositoryProtocol
    
    private var items = [Item]()
    private var repositoryFetchTask: Task<Void, Never>?
    private var lastSnapshot: NSDiffableDataSourceSnapshot<Int, ItemCell.ViewModel>?
    
    init(itemsRepository: ItemsRepositoryProtocol) {
        self.itemsRepository = itemsRepository
        repositoryFetchTask = Task {
            for await items in await itemsRepository.updates {
                self.items = items
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
        
        let currentVMs = items.map(ItemCell.ViewModel.init)
        snapshot.appendItems(currentVMs)
        
        let updatedVMs = currentVMs.filter { viewModel in
            let viewModelInPrevious = lastSnapshot?.itemIdentifiers.first { $0 == viewModel }
            guard let viewModelInPrevious else { return false }
            return viewModelInPrevious.isFavorite != viewModel.isFavorite
        }
        snapshot.reconfigureItems(updatedVMs)
    
        lastSnapshot = snapshot
        return snapshot
    }
    
    func markItems(at indexPaths: [IndexPath], asFavorite: Bool) async {
        onLoading?(true)
        let ids = indexPaths.compactMap { items[safe: $0.row]?.id }
        await itemsRepository.markItems(with: ids, asFavorite: asFavorite)
        onLoading?(false)
    }
    
    func toggleItemIsFavorite(at indexPath: IndexPath) async {
        guard let item = items[safe: indexPath.row] else { return }
        await markItems(at: [indexPath], asFavorite: !item.isFavorite)
    }
    
    func getLeadingSwipeActions(for indexPath: IndexPath) -> [SwipeActionVM]? {
        guard let item = items[safe: indexPath.row] else { return nil }
        let isFavorite = item.isFavorite
        let title = isFavorite ? "Remove from favorite" : "Mark as favorite"
        let actionVM = SwipeActionVM(title: title) { [weak self] completion in
            Task {
                await self?.markItems(at: [indexPath], asFavorite: !isFavorite)
                completion(true)
            }
        }
        return [actionVM]
    }
    
    func canMarkFavorite(at indexPaths: [IndexPath]) -> Bool {
        return indexPaths.contains {
            items[safe: $0.row]?.isFavorite == false
        }
    }
    
    func canRemoveFromFavorite(at indexPaths: [IndexPath]) -> Bool {
        return indexPaths.contains {
            items[safe: $0.row]?.isFavorite == true
        }
    }
}
