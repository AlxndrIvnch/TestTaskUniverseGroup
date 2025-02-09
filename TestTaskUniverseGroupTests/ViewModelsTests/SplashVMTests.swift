//
//  SplashVMTests.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/9/25.
//

import Testing
@testable import TestTaskUniverseGroup

@MainActor
final class SplashVMTests {
    
    private let fakeLoader = ItemsLoaderMock()
    private let fakeStore = ItemsStoreMock()
    
    private var progress: Float = 0
    private var errorMessage: String?
    
    @Test(.timeLimit(.minutes(1)))
    func testViewDidLoadSuccess() async {
        await withUnsafeContinuation { continuation in
            let splashVM = SplashVM(itemsLoader: fakeLoader,
                                    itemsStore: fakeStore,
                                    onLoadedItems: { continuation.resume() })
            
            splashVM.onProgress = { [weak self] in
                self?.progress = $0
            }
            splashVM.onError = {  [weak self] in
                self?.errorMessage = $0
            }
            
            splashVM.viewDidLoad()
            splashVM.progressFillAnimationEnded()
        }
        await #expect(fakeStore.items.count == 1, "Fake store should have one item")
        #expect(progress == 1.0, "Progress should be 1.0")
        #expect(errorMessage == nil, "There should be no error")
    }
}
