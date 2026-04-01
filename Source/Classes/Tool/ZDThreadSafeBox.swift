//
//  ZDThreadSafeBox.swift
//  Pods
//
//  Created by Zero_D_Saber on 2025/7/31.
//

import Synchronization

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
public struct ZDThreadSafeBox<T>: ~Copyable where T: Sendable {
    // MARK: Properties

    private let mutex: Mutex<T>

    // MARK: Computed Properties

    /// Returns a thread-safe snapshot of the current value.
    ///
    /// Example:
    /// ```swift
    /// let box = ZDThreadSafeBox(0)
    /// print(box.value) // 0
    /// ```
    public var value: T {
        mutex.withLock { $0 }
    }

    // MARK: Lifecycle

    init(_ value: T) {
        mutex = Mutex(value)
    }

    // MARK: Functions

    /// Performs an in-place mutation under lock.
    ///
    /// - Parameter transform: Mutation closure executed while the lock is held.
    ///
    /// Example:
    /// ```swift
    /// let box = ZDThreadSafeBox(0)
    /// box.update { $0 += 1 }
    /// print(box.value) // 1
    /// ```
    public func update(_ transform: (inout T) -> Void) {
        mutex.withLock { value in
            transform(&value)
        }
    }
}
