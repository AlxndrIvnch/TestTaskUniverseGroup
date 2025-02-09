//
//  SwipeActionVM.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import UIKit

struct SwipeActionVM {
    
    let title: String?
    let isDestructive: Bool
    let action: SimpleCallbackClosure<Bool>
    
    init(title: String? = nil,
         isDestructive: Bool = false,
         action: @escaping SimpleCallbackClosure<Bool>) {
        self.title = title
        self.isDestructive = isDestructive
        self.action = action
    }
}
