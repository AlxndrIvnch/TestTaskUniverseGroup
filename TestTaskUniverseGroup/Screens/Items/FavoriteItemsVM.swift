//
//  FavoriteItemsVM.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import Foundation
import RxSwift
import RxCocoa

final class FavoriteItemsVM: ItemsVMProtocol {
    
    let input: ItemsVMInput
    let output: ItemsVMOutput
    
    private let title = Infallible.just(String(localized: "favorite_items_screen_title"))
    private let favoriteItems = BehaviorRelay<[Item]>(value: [])
    private let cellVMs: Infallible<[ItemCell.ViewModel]>
    private let emptyStateText: Infallible<String?>
    private let showMarkFavoriteButton = Infallible.just(true)
    private let canMarkFavorite = Infallible.just(false)
    private let showRemoveFromFavoriteButton = Infallible.just(true)
    private let canRemoveFromFavorite: Infallible<Bool>
    private let selectedIDs: Infallible<[Int]>
    private let viewWillAppear = PublishRelay<Void>()
    private let didSelectRow = PublishRelay<IndexPath>()
    private let indexPathsForSelectedRows = PublishRelay<[IndexPath]>()
    private let markItemsAction = PublishRelay<Bool>()
    private let disposeBag = DisposeBag()
    
    init(itemsStore: ItemsStoreProtocol) {
        
        itemsStore.items
            .flatMap {
                Observable.from($0)
                    .filter(\.isFavorite)
                    .toArray()
            }
            .bind(to: favoriteItems)
            .disposed(by: disposeBag)
        
        cellVMs = Infallible.merge(
            favoriteItems.asInfallible(),
            viewWillAppear
                .asInfallible()
                .withLatestFrom(favoriteItems.asInfallible())
        )
        .flatMap {
            Observable.from($0)
                .map(ItemCell.ViewModel.init)
                .toArray()
        }
        
        emptyStateText = cellVMs
            .map { $0.isEmpty ? String(localized: "favorites_empty") : nil }
        
        canRemoveFromFavorite = indexPathsForSelectedRows
            .asInfallible()
            .map { !$0.isEmpty }
        
        selectedIDs = indexPathsForSelectedRows
            .asInfallible()
            .withLatestFrom(
                favoriteItems.asInfallible(),
                resultSelector: { indexPaths, items in
                    indexPaths.compactMap { items[safe: $0.row]?.id }
                }
            )
        
        input = .init(
            viewWillAppear: viewWillAppear,
            didSelectRow: didSelectRow,
            indexPathsForSelectedRows: indexPathsForSelectedRows,
            markItemsAction: markItemsAction
        )
        
        output = .init(
            title: title.asDriver(),
            emptyStateText: emptyStateText.asDriver(),
            cellVMs: cellVMs.asDriver(),
            canMarkFavorite: canMarkFavorite.asDriver(),
            showMarkFavoriteButton: showMarkFavoriteButton.asDriver(),
            canRemoveFromFavorite: canRemoveFromFavorite.asDriver(),
            showRemoveFromFavoriteButton: showRemoveFromFavoriteButton.asDriver()
        )
        
        didSelectRow
            .asInfallible()
            .withLatestFrom(
                favoriteItems.asInfallible(),
                resultSelector: { indexPath, items in
                    guard let item = items[safe: indexPath.row] else { return nil }
                    return (ids: [item.id], asFavorite: false)
                }
            )
            .compactMap { $0 }
            .bind(onNext: itemsStore.markItems)
            .disposed(by: disposeBag)
        
        markItemsAction
            .asInfallible()
            .withLatestFrom(
                selectedIDs,
                resultSelector: {
                    asFavorite, ids in (ids, asFavorite: false)
                }
            )
            .bind(onNext: itemsStore.markItems)
            .disposed(by: disposeBag)
    }
    
    func getLeadingSwipeActions(for indexPath: IndexPath) -> [SwipeActionVM]? {
        let actionVM = SwipeActionVM(
            title: String(localized: "remove_item_from_favorites"),
            isDestructive: true
        ) { [weak self] completion in
            self?.didSelectRow.accept(indexPath)
            completion(true)
        }
        return [actionVM]
    }
}
