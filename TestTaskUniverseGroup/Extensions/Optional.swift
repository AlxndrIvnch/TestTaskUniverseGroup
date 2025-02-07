//
//  Optional.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import Foundation

extension Swift.Optional where Wrapped: Collection {
    
    var isNilOrEmpty: Bool { self?.isEmpty ?? true }
}
