//
//  ItemsVMProtocol.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import Foundation
import UIKit.NSDiffableDataSourceSectionSnapshot

@MainActor
protocol ItemsVMProtocol: AnyObject {
    var onUpdateUI: EmptyClosure? { get set }
    var onLoading: SimpleClosure<Bool>? { get set }
    
    var title: String { get }
    var showRemoveFromFavoriteButton: Bool { get }
    var showMarkFavoriteButton: Bool { get }
    var textWhenEmpty: String { get }
    
    func createSnapshot() -> NSDiffableDataSourceSnapshot<Int, ItemCell.ViewModel>
    func markItems(at indexPaths: [IndexPath], asFavorite: Bool) async
    func toggleItemIsFavorite(at indexPath: IndexPath) async
    func getLeadingSwipeActions(for indexPath: IndexPath) -> [SwipeActionVM]?
    func canMarkFavorite(at indexPaths: [IndexPath]) -> Bool
    func canRemoveFromFavorite(at indexPaths: [IndexPath]) -> Bool
}
