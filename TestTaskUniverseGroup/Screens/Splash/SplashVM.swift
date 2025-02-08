//
//  SplashVM.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

@MainActor
struct SplashVM {
    
    var onError: SimpleClosure<String>?
    
    private let dataService: DataServiceProtocol
    private let itemsRepository: ItemsRepositoryProtocol
    private let onLoadedData: EmptyClosure
    
    init(dataService: DataServiceProtocol,
         itemsRepository: ItemsRepositoryProtocol,
         onLoadedData: @escaping EmptyClosure) {
        self.dataService = dataService
        self.itemsRepository = itemsRepository
        self.onLoadedData = onLoadedData
    }
    
    func viewDidLoad() {
        Task {
            do {
                let items = try await dataService.loadData()
                await itemsRepository.setItems(items)
                onLoadedData()
            } catch {
                onError?("Data loading failed. Please try again later.")
            }
        }
    }
}
