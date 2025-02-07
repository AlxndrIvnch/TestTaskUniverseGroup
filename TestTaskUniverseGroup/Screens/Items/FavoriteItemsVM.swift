//
//  FavoriteItemsVM.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import Foundation

final class FavoriteItemsVM: ItemsVMProtocol {
    
    var onUpdateUI: EmptyClosure?
    var onLoading: SimpleClosure<Bool>?
    
    var title: String { "Favorite Items" }
    var showMarkFavoriteButton: Bool { false }
    var showRemoveFromFavoriteButton: Bool { true }
    
    private let itemsRepository: ItemsRepositoryProtocol
    
    private var favoriteItems: [Item] = []
    
    init(itemsRepository: ItemsRepositoryProtocol) {
        self.itemsRepository = itemsRepository
        Task {
            for await items in await itemsRepository.updates {
                favoriteItems = items.filter(\.isFavorite)
                onUpdateUI?()
            }
        }
    }
    
    func getNumberOfRows() -> Int {
        return favoriteItems.count
    }
    
    func getCellVM(for indexPath: IndexPath) -> String? {
        return favoriteItems[safe: indexPath.row]?.title
    }
    
    func markItems(asFavorite: Bool, at indexPaths: [IndexPath]) async {
        onLoading?(true)
        for indexPath in indexPaths {
            guard let item = favoriteItems[safe: indexPath.row] else { continue }
            await itemsRepository.toggleIsFavorite(for: item.id)
        }
        onLoading?(false)
    }
    
    func getLeadingSwipeActions(for indexPath: IndexPath) -> [SwipeActionVM]? {
        let actionVM = SwipeActionVM(title: "Remove from favorite") { [weak self] completion in
            Task {
                await self?.markItems(asFavorite: false, at: [indexPath])
                completion(true)
            }
        }
        return [actionVM]
    }
    
    func canMarkFavorite(for indexPaths: [IndexPath]) -> Bool {
        return false
    }
    
    func canRemoveFromFavorite(for indexPaths: [IndexPath]) -> Bool {
        return true
    }
}
