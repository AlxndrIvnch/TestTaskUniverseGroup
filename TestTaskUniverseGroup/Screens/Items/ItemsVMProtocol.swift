//
//  ItemsVMProtocol.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol ItemsVMProtocol: AnyObject {
    var input: ItemsVMInput { get }
    var output: ItemsVMOutput { get }
    
    func getLeadingSwipeActions(for indexPath: IndexPath) -> [SwipeActionVM]? // ?
}

struct ItemsVMInput {
    let viewWillAppear: PublishRelay<Void>
    let didSelectRow: PublishRelay<IndexPath>
    let indexPathsForSelectedRows: PublishRelay<[IndexPath]>
    let markItemsAction: PublishRelay<Bool>
}

struct ItemsVMOutput {
    let title: Driver<String>
    let emptyStateText: Driver<String?>
    let cellVMs: Driver<[ItemCell.ViewModel]>
    let canMarkFavorite: Driver<Bool>
    let showMarkFavoriteButton: Driver<Bool>
    let canRemoveFromFavorite: Driver<Bool>
    let showRemoveFromFavoriteButton: Driver<Bool>
}
