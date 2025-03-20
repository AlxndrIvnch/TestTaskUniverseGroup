//
//  ItemsLoader.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol ItemsLoaderProtocol {
    func loadItems(progress: AnyObserver<Float>?) -> Single<[Item]>
}

extension ItemsLoaderProtocol {
    func loadItems() -> Single<[Item]> {
        return loadItems(progress: nil)
    }
}

final class ItemsLoader: ItemsLoaderProtocol {
    func loadItems(progress: AnyObserver<Float>? = nil) -> Single<[Item]> {
        let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        return Single.create { single in
            let steps = 15
            let items = (1...100).map { Item(id: $0, title: "Item \($0)", isFavorite: false) }
            return Observable.range(start: 1, count: steps)
                .concatMap { step in
                    let delay = Int.random(in: 1...500)
                    let progress = Float(Double(step) / Double(steps))
                    return Observable.just(progress)
                        .delay(.milliseconds(delay), scheduler: backgroundScheduler)
                }
                .subscribe(
                    onNext: progress?.onNext,
                    onError: { single(.failure($0)) },
                    onCompleted: { single(.success(items)) }
                )
        }
        .subscribe(on: backgroundScheduler)
    }
}
