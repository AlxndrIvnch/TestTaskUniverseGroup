//
//  ItemCellVM.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/8/25.
//

import Foundation

extension ItemCell {
    
    struct ViewModel: Hashable {
        
        var text: String { model.title }
        var isFavorite: Bool { model.isFavorite }
        
        private let model: Item
        
        init(model: Item) {
            self.model = model
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(model.id)
        }
        
        static func == (lhs: ViewModel, rhs: ViewModel) -> Bool {
            return lhs.model.id == rhs.model.id
        }
    }
}
