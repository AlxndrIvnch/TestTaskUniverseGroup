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
        let progressAnimationCompleted: PublishRelay<Float>
    }
    
    struct Output {
        let progress: Driver<Float>
        let error: Driver<String?>
    }
        
    let input: Input
    let output: Output
    
    private let viewDidLoad = PublishRelay<Void>()
    private let progressAnimationCompleted = PublishRelay<Float>()
    private let progress = PublishRelay<Float>()
    private let error = PublishRelay<String?>()
    private let disposeBag = DisposeBag()
    
    init(itemsLoader: ItemsLoaderProtocol,
         itemsStore: ItemsStoreProtocol,
         onLoadedItems: @escaping EmptyClosure) {
        
        input = .init(
            viewDidLoad: viewDidLoad,
            progressAnimationCompleted: progressAnimationCompleted
        )
        
        output = .init(
            progress: progress
                .startWith(0)
                .asDriver(onErrorDriveWith: .empty()),
            error: error
                .startWith(nil)
                .asDriver(onErrorDriveWith: .empty())
        )

        viewDidLoad
            .asInfallible()
            .flatMap { [unowned self] in
                itemsLoader.loadItems(progress: progress)
                    .do(onError: { [unowned self] _ in
                        error.accept(String(localized: "loading_error"))
                    })
                    .asInfallible(onErrorFallbackTo: .empty())
            }
            .bind(onNext: itemsStore.setItems)
            .disposed(by: disposeBag)
        
        progressAnimationCompleted
            .skip { $0 < 1 }
            .subscribe(onNext: { _ in onLoadedItems() })
            .disposed(by: disposeBag)
    }
}
