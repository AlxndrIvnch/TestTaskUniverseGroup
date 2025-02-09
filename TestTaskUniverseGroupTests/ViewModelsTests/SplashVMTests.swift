//
//  SplashVMTests.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/9/25.
//

import Testing
@testable import TestTaskUniverseGroup

struct SplashVMTests {
    
    private let fakeLoader = ItemsLoaderMock()
    private let fakeStore = ItemsStoreMock()
    
    @Test(.timeLimit(.minutes(1)))
    func testViewDidLoadSuccess() async {
        var progress: Float = 0
        var errorMessage: String?
        
        await withUnsafeContinuation { @Sendable continuation in
            Task { @MainActor in
                let splashVM = SplashVM(itemsLoader: fakeLoader,
                                        itemsStore: fakeStore,
                                        onLoadedItems: { continuation.resume() })
                
                splashVM.onProgress = { progress = $0 }
                splashVM.onError = { errorMessage = $0 }
                
                splashVM.viewDidLoad()
                splashVM.progressFillAnimationEnded()
            }
        }
        
        await #expect(fakeStore.items.count == 1, "Fake store should have one item")
        #expect(progress == 1.0, "Progress should be 1.0")
        #expect(errorMessage == nil, "There should be no error")
    }
}
