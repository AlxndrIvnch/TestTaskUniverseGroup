//
//  ItemCellVM.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/8/25.
//

import Foundation
import RxDataSources

extension ItemCell {
    
    struct ViewModel: IdentifiableType, Equatable {
        
        var identity: Int { model.id }
        var text: String { model.title }
        var isFavorite: Bool { model.isFavorite }
        
        private let model: Item
        
        init(model: Item) {
            self.model = model
        }
    }
}
