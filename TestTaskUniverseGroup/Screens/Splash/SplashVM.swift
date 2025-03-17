//
//  SplashVM.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SplashVM {
    
    struct Input {
        let viewDidLoad: PublishRelay<Void>
        let progressAnimationComplete: PublishRelay<Float>
    }
    
    struct Output {
        let progress: Driver<Float>
        let error: Driver<String?>
    }
        
    let input: Input
    let output: Output
    
    private let itemsLoader: ItemsLoaderProtocol
    private let itemsStore: ItemsStoreProtocol
    private let disposeBag = DisposeBag()
    
    init(itemsLoader: ItemsLoaderProtocol,
         itemsStore: ItemsStoreProtocol,
         onLoadedItems: @escaping EmptyClosure) {
        self.itemsLoader = itemsLoader
        self.itemsStore = itemsStore

        let viewDidLoad = PublishRelay<Void>()
        let progressAnimationComplete = PublishRelay<Float>()
        input = .init(
            viewDidLoad: viewDidLoad,
            progressAnimationComplete: progressAnimationComplete
        )
        
        let progress = BehaviorRelay<Float>(value: 0)
        let error = BehaviorRelay<String?>(value: nil)
        output = .init(
            progress: progress.asDriver(),
            error: error.asDriver()
        )
        
        viewDidLoad
            .asInfallible()
            .flatMap {
                itemsLoader.loadItems(progress: progress)
                    .do(onError: { _ in error.accept(String(localized: "loading_error")) })
                    .asInfallible(onErrorFallbackTo: .empty())
            }
            .bind(to: itemsStore.input.setItems)
            .disposed(by: disposeBag)
        
        progressAnimationComplete
            .skip { $0 < 1 }
            .subscribe(onNext: { _ in onLoadedItems() })
            .disposed(by: disposeBag)
    }
}
