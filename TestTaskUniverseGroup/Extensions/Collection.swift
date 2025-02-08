//
//  Collection.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
       return indices.contains(index) ? self[index] : nil
    }
}

extension MutableCollection where Self: RangeReplaceableCollection {
    subscript(safe index: Index) -> Element? {
        get { indices.contains(index) ? self[index] : nil }
        set {
            guard indices.contains(index) else { return }
            if let newValue {
                self[index] = newValue
            } else {
                remove(at: index)
            }
        }
    }
}
