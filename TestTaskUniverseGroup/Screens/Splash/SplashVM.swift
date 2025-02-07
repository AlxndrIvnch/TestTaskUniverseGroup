//
//  SplashVM.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

@MainActor
struct SplashVM {
    
    let onLoaded: SimpleClosure<[String]>
    
    func loadData() {
        Task { //TODO: Get from service
            try await Task.sleep(for: .seconds(3))
            onLoaded([])
        }
    }
}
