//
//  Typealiases.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import Foundation

typealias EmptyClosure = () -> Void
typealias SimpleClosure<Value> = (Value) -> Void
typealias SimpleCallbackClosure<Value> = (@escaping SimpleClosure<Value>) -> Void
