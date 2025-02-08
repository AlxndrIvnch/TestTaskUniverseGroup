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
                onLoadedItems()
            } catch {
                onError?(String(localized: "loading_error"))
            }
        }
    }
}
