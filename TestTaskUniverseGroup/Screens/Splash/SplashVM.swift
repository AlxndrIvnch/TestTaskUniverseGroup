//
//  SplashVM.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

@MainActor
final class SplashVM {
    
    var onProgress: SimpleClosure<Float>?
    var onError: SimpleClosure<String>?
    
    private let itemsLoader: ItemsLoaderProtocol
    private let itemsStore: ItemsStoreProtocol
    private let onLoadedItems: EmptyClosure
    
    private var savedItemsToStore = false
    private var progressBarFilled = false
    
    init(itemsLoader: ItemsLoaderProtocol,
         itemsStore: ItemsStoreProtocol,
         onLoadedItems: @escaping EmptyClosure) {
        self.itemsLoader = itemsLoader
        self.itemsStore = itemsStore
        self.onLoadedItems = onLoadedItems
    }
    
    func viewDidLoad() {
        Task {
            do {
                let items = try await itemsLoader.loadItems(progressHandler: { [weak self] progress in
                    Task { @MainActor in
                        self?.onProgress?(Float(progress))
                    }
                })
                await itemsStore.setItems(items)
                savedItemsToStore = true
                invokeCompletionIfNeeded()
            } catch {
                onError?(String(localized: "loading_error"))
            }
        }
    }
    
    func progressFillAnimationEnded() {
        progressBarFilled = true
        invokeCompletionIfNeeded()
    }
    
    private func invokeCompletionIfNeeded() {
        guard savedItemsToStore && progressBarFilled else { return }
        onLoadedItems()
    }
}
