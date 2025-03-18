//
//  ItemsStore.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import Foundation
import RxSwift
import RxRelay

protocol ItemsStoreProtocol {
    var items: Infallible<[Item]> { get }
    
    func setItems(_ items: [Item])
    func markItems(with ids: [Int], asFavorite: Bool)
}

final class ItemsStore: ItemsStoreProtocol {
    
    var items: Infallible<[Item]> { itemsRelay.asInfallible() }
    
    private let itemsRelay = BehaviorRelay<[Item]>(value: [])
    private let serialScheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "com.example.itemsStore")
    private let disposeBag = DisposeBag()
    
    func setItems(_ items: [Item]) {
        Observable.just(items)
            .observe(on: serialScheduler)
            .bind(to: itemsRelay)
            .disposed(by: disposeBag)
    }
    
    func markItems(with ids: [Int], asFavorite: Bool) {
        itemsRelay
            .observe(on: serialScheduler)
            .take(1)
            .map { currentItems in
                ids.reduce(into: currentItems) { items, itemId in
                    guard let index = items.firstIndex(where: { $0.id == itemId }) else { return }
                    items[index].isFavorite = asFavorite
                }
            }
            .bind(to: itemsRelay)
            .disposed(by: disposeBag)
    }
}
