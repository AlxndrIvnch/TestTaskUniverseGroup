//
//  AllItemsVM.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import Foundation
import RxSwift
import RxCocoa

final class AllItemsVM: ItemsVMProtocol {
    
    let input: ItemsVMInput
    let output: ItemsVMOutput
    
    private let title = Infallible.just(String(localized: "all_items_screen_title"))
    private let items = BehaviorRelay<[Item]>(value: [])
    private let cellVMs: Infallible<[ItemCell.ViewModel]>
    private let emptyStateText: Infallible<String?>
    private let showMarkFavoriteButton = Infallible.just(true)
    private let canMarkFavorite: Infallible<Bool>
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
            .bind(to: items)
            .disposed(by: disposeBag)
        
        cellVMs = Infallible.merge(
            items.asInfallible(),
            viewWillAppear
                .asInfallible()
                .withLatestFrom(items.asInfallible())
        )
        .flatMap {
            Observable.from($0)
                .map(ItemCell.ViewModel.init)
                .toArray()
        }
        
        emptyStateText = cellVMs
            .map { $0.isEmpty ? String(localized: "no_items") : nil }
        
        
        canMarkFavorite = Infallible.combineLatest(
            indexPathsForSelectedRows.asInfallible(),
            items.asInfallible(),
            resultSelector: { indexPaths, items in
                return indexPaths.contains {
                    items[safe: $0.row]?.isFavorite == false
                }
            }
        )
        
        canRemoveFromFavorite = Infallible.combineLatest(
            indexPathsForSelectedRows.asInfallible(),
            items.asInfallible(),
            resultSelector: { indexPaths, items in
                return indexPaths.contains {
                    items[safe: $0.row]?.isFavorite == true
                }
            }
        )
        
        selectedIDs = indexPathsForSelectedRows
            .asInfallible()
            .withLatestFrom(
                items.asInfallible(),
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
                items.asInfallible(),
                resultSelector: { indexPath, items in
                    guard let item = items[safe: indexPath.row] else { return nil }
                    return (ids: [item.id], asFavorite: !item.isFavorite)
                }
            )
            .compactMap { $0 }
            .bind(onNext: itemsStore.markItems)
            .disposed(by: disposeBag)
        
        markItemsAction
            .asInfallible()
            .withLatestFrom(
                selectedIDs,
                resultSelector: { asFavorite, ids in
                    (ids, asFavorite)
                }
            )
            .bind(onNext: itemsStore.markItems)
            .disposed(by: disposeBag)
    }
    
    func getLeadingSwipeActions(for indexPath: IndexPath) -> [SwipeActionVM]? {
        guard let item = items.value[safe: indexPath.row] else { return nil }
        let isFavorite = item.isFavorite
        let title = isFavorite ? String(localized: "remove_item_from_favorites") : String(localized: "add_item_to_favorites")
        let actionVM = SwipeActionVM(title: title, isDestructive: isFavorite) { [weak self] completion in
            self?.didSelectRow.accept(indexPath)
            completion(true)
        }
        return [actionVM]
    }
}
