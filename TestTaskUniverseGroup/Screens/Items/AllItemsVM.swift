//
//  AllItemsVM.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import Foundation

final class AllItemsVM: ItemsVMProtocol {
    
    var onUpdateUI: EmptyClosure?
    var onLoading: SimpleClosure<Bool>?
    
    var title: String { "All Items" }
    var showRemoveFromFavoriteButton: Bool { true }
    var showMarkFavoriteButton: Bool { true }
    
    private let itemsRepository: ItemsRepositoryProtocol
    
    private var items = [Item]()
    private var repositoryFetchTask: Task<Void, Never>?
    
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
    
    func getNumberOfRows() -> Int {
        return items.count
    }
    
    func getCellVM(for indexPath: IndexPath) -> String? {
        return items[safe: indexPath.row]?.title
    }
    
    func markItems(asFavorite: Bool, at indexPaths: [IndexPath]) async {
        onLoading?(true)
        for indexPath in indexPaths {
            guard let item = items[safe: indexPath.row] else { continue }
            await itemsRepository.toggleIsFavorite(for: item.id)
        }
        onLoading?(false)
    }
    
    func getLeadingSwipeActions(for indexPath: IndexPath) -> [SwipeActionVM]? {
        guard let item = items[safe: indexPath.row] else { return nil }
        let isFavorite = item.isFavorite
        let title = isFavorite ? "Remove from favorite" : "Mark as favorite"
        let actionVM = SwipeActionVM(title: title) { [weak self] completion in
            Task {
                await self?.markItems(asFavorite: !isFavorite, at: [indexPath])
                completion(true)
            }
        }
        return [actionVM]
    }
    
    func canMarkFavorite(for indexPaths: [IndexPath]) -> Bool {
        return indexPaths.contains {
            items[safe: $0.row]?.isFavorite == false
        }
    }
    
    func canRemoveFromFavorite(for indexPaths: [IndexPath]) -> Bool {
        return indexPaths.contains {
            items[safe: $0.row]?.isFavorite == true
        }
    }
}
