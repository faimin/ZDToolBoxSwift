//
//  ZDThreadSafeBox.swift
//  Pods
//
//  Created by Zero_D_Saber on 2025/7/31.
//

import Synchronization

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
public struct ZDThreadSafeBox<T>: ~Copyable {
    private let mutex: Mutex<T>

    init(_ value: T) {
        mutex = Mutex(value)
    }

    func update(_ transform: (inout T) -> Void) {
        mutex.withLock { value in
            transform(&value)
        }
    }

    func value() -> T {
        mutex.withLock { $0 }
    }
}
