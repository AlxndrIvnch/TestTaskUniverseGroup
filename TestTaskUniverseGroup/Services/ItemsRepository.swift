//
//  ItemsRepository.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import Foundation

protocol ItemsRepositoryProtocol: Actor {
    var items: [Item] { get }
    var updates: AsyncStream<[Item]> { get }
    func save(_ items: [Item])
    func toggleIsFavorite(for itemID: Int)
}

actor ItemsRepository: ItemsRepositoryProtocol {
    
    static let shared = ItemsRepository()
    
    private(set) var items: [Item] = [] {
        didSet { continuations.forEach { $0.yield(items) } }
    }
    
    var updates: AsyncStream<[Item]> {
        AsyncStream { continuation in
            continuation.yield(items)
            continuations.append(continuation)
        }
    }
    
    private var continuations = [AsyncStream<[Item]>.Continuation]()
    
    private init() {}
    
    func save(_ items: [Item]) {
        self.items = items
     }
    
    func toggleIsFavorite(for itemID: Int) {
        guard let index = items.firstIndex(where: { $0.id == itemID }) else { return }
        items[index].isFavorite.toggle()
    }
}
