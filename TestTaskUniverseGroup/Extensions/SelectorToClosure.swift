//
//  SelectorToClosure.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import UIKit

@objc fileprivate class ClosureHolder: NSObject {
    
    private let closure: EmptyClosure
    
    init(_ closure: @escaping EmptyClosure) {
        self.closure = closure
    }
    
    @objc func invoke() {
        closure()
    }
}

extension UIBarButtonItem {
    
    @objc func addAction(_ closure: @escaping EmptyClosure) {
        let closureHolder = ClosureHolder(closure)
        target = closureHolder
        action = #selector(ClosureHolder.invoke)
        objc_setAssociatedObject(self,
                                 UUID().uuidString,
                                 closureHolder,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

extension UIControl {
    
    @objc func addAction(for controlEvents: UIControl.Event = .touchUpInside,
                         _ closure: @escaping EmptyClosure) {
        addAction(.init { _ in closure() }, for: controlEvents)
    }
}
