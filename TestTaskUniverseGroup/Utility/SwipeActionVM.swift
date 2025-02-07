//
//  SwipeActionVM.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import UIKit

struct SwipeActionVM {
    
    let title: String?
    let image: UIImage?
    let action: SimpleCallbackClosure<Bool>
    
    init(title: String? = nil,
         image: UIImage? = nil,
         action: @escaping SimpleCallbackClosure<Bool>) {
        self.title = title
        self.image = image
        self.action = action
    }
}
