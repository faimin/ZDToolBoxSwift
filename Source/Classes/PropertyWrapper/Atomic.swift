//
//  Atomic.swift
//  ZDSwiftToolKit
//
//  Created by Zero.D.Saber on 2021/9/9.
//

import Foundation

@propertyWrapper
public struct Atomic<Value> {
    private var value: Value
    private let lock = os_unfair_lock()

    public init(wrappedValue value: Value) {
        self.value = wrappedValue
    }

    public var wrappedValue: Value {
        get {
            lock.lock()
            defer { lock.unlock() }
            return value
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            value = newValue
        }
    }
}