//
//  Atomic.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/9/9.
//

import Darwin.os.lock

@propertyWrapper
public struct Atomic<Value> {
    // MARK: Properties

    private var value: Value
    private var lock = os_unfair_lock()

    // MARK: Computed Properties

    /// Thread-safe wrapped value.
    ///
    /// Example:
    /// ```swift
    /// @Atomic var count = 0
    /// count += 1
    /// ```
    public var wrappedValue: Value {
        mutating get {
            os_unfair_lock_lock(&lock)
            defer { os_unfair_lock_unlock(&lock) }
            return value
        }
        mutating set {
            os_unfair_lock_lock(&lock)
            defer { os_unfair_lock_unlock(&lock) }
            value = newValue
        }
    }

    // MARK: Lifecycle

    /// Creates an atomic wrapper.
    ///
    /// - Parameter value: Initial wrapped value.
    public init(wrappedValue value: Value) {
        self.value = value
    }
}
