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
        let viewDidLoad: AnyObserver<Void>
        let progressAnimationCompleted: AnyObserver<Float>
    }
    
    struct Output {
        let progress: Driver<Float>
        let error: Driver<String?>
        let itemsLoaded: Infallible<Void>
    }
        
    let input: Input
    let output: Output
    
    private let viewDidLoad = PublishSubject<Void>()
    private let progressAnimationCompleted = PublishSubject<Float>()
    private let progress = PublishSubject<Float>()
    private let error = PublishSubject<String?>()
    private let itemsLoaded = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    init(itemsLoader: ItemsLoaderProtocol,
         itemsStore: ItemsStoreProtocol) {
        
        input = .init(
            viewDidLoad: viewDidLoad.asObserver(),
            progressAnimationCompleted: progressAnimationCompleted.asObserver()
        )
        
        output = .init(
            progress: progress
                .startWith(0)
                .asDriver(onErrorDriveWith: .empty()),
            error: error
                .startWith(nil)
                .asDriver(onErrorDriveWith: .empty()),
            itemsLoaded: itemsLoaded.asInfallible()
        )

        viewDidLoad
            .asInfallible(onErrorFallbackTo: .empty())
            .flatMap { [unowned self] in
                itemsLoader.loadItems(progress: progress.asObserver())
                    .do(onError: { [unowned self] _ in
                        error.onNext(String(localized: "loading_error"))
                    })
                    .asInfallible(onErrorFallbackTo: .empty())
            }
            .bind(onNext: itemsStore.setItems)
            .disposed(by: disposeBag)
        
        progressAnimationCompleted
            .asInfallible(onErrorFallbackTo: .empty())
            .skip { $0 < 1 }
            .map { _ in }
            .bind(onNext: itemsLoaded.accept)
            .disposed(by: disposeBag)
    }
}
