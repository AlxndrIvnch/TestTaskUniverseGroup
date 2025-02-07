//
//  ItemsVMProtocol.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import Foundation

@MainActor
protocol ItemsVMProtocol: AnyObject {
    var onUpdateUI: EmptyClosure? { get set }
    var onLoading: SimpleClosure<Bool>? { get set }
    
    var title: String { get }
    var showRemoveFromFavoriteButton: Bool { get }
    var showMarkFavoriteButton: Bool { get }
    
    func getNumberOfRows() -> Int
    func getCellVM(for indexPath: IndexPath) -> String?
    func markItems(asFavorite: Bool, at indexPaths: [IndexPath]) async
    func getLeadingSwipeActions(for indexPath: IndexPath) -> [SwipeActionVM]?
    func canMarkFavorite(for indexPaths: [IndexPath]) -> Bool
    func canRemoveFromFavorite(for indexPaths: [IndexPath]) -> Bool
}
